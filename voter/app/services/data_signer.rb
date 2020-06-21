=begin
 DataSigner is responsible for handling messages.
 This includes encryption, blinding, signing the message by admin module and veryfing the correctness of the message
=end

require 'openssl'
require 'digest'

class DataSigner
  attr_reader :admin_client
  #
  # == Parameters:
  # private_key::
  #  Must be an RSA 512 bit length private key (string)
  # encryptor::
  #  object that can respond to encrypt method
  #  Encryptor is responsible for encrypting the candidate info and is used to generate the bit commitment that user has made
  # signer::
  #  signer is an object responsible for blinding, signing and unblinding already signed messages
  def initialize(private_key: nil, encryptor: OnlineVoting::Crypto::Message, signer: OnlineVoting::Crypto::BlindSigner, admin_client: OnlineVoting::AdminClient)
    @signer = signer.new
    @private_key = private_key
    @encryptor = encryptor
    @admin_client = admin_client.new(uri: Voter.config.administrator_module_uri)
  end

  #
  # == Parameters:
  # message::
  #  must be a string. Becuase of current limitation a string of max 23 bytes
  # encryptor::
  #  object that can respond to encrypt method
  #  Encryptor is responsible for encrypting the candidate info and is used to generate the bit commitment that user has made
  # signer::
  #  signer is an object responsible for blinding, signing and unblinding already signed messages
  # == Returns:
  # === DataSignerResult object
  def sign_vote(message, voter_id, key = nil, iv = nil)
    encrypted_msg, msg_key, iv = @encryptor.encrypt(message.to_json, key, iv)
    encoded_encrypted_msg = Base64.encode64(encrypted_msg)
    blinded_encoded_encrypted_msg, r = rsa.blind(encoded_encrypted_msg, admin_key)
    voter_signed_blinded_encoded_encrypted_msg = rsa._sign(blinded_encoded_encrypted_msg, voter_key)

    admin_response = admin_client.get_admin_signature(
      voter_id,
      blinded_encoded_encrypted_msg,
      voter_signed_blinded_encoded_encrypted_msg,
      voter_key.public_key.to_s)


    raise AdminSignatureError if admin_response.to_s == "" || admin_response['error']

    admin_signed_blinded_encoded_encrypted_msg = admin_response['data']['admin_signature']
    admin_signed_encoded_encrypted_msg = rsa.unblind(admin_signed_blinded_encoded_encrypted_msg, r, admin_key)

    msg_int = rsa.text_to_int(encoded_encrypted_msg)

    if rsa.verify(signed: admin_signed_encoded_encrypted_msg, message: msg_int, key: admin_key)
      puts "\n UNBLINDED SINGED IS VERIFIED!\n"
    else
      raise AdminSignatureError.new("unblinded signature invalid")
    end

    DataSignerResult.new(msg_int, blinded_encoded_encrypted_msg, admin_signed_blinded_encoded_encrypted_msg, r, voter_key.to_s, msg_key, Base64.encode64(iv))
  end

  #
  # == Parameters:
  # signed_message::
  #  message that was blinded and signed
  # r::
  #  blinding factor that was used to blind the signed_message
  # signing_key::
  #  key that was used to sign the message
  def unblind_message(signed_message, r, signing_key = admin_key)
    unblinded_signed_message = rsa.unblind(signed_message, r, signing_key)
  end

  #
  # == Parameters:
  # signed_message::
  #  message that was blinded and signed
  # message::
  #  original message
  # signing_key::
  #  key that was used to sign the message
  def verify(signed_message, message, signing_key = admin_key)
    msg_int = rsa.text_to_int(message)
    rsa.verify(signed: signed_message, message: msg_int, key: signing_key)
  end

  class AdminSignatureError < StandardError
  end

  private

  def voter_key
    @voter_key ||= @private_key ? OpenSSL::PKey.read(@private_key) : generate_key
  end

  def admin_key
    @admin_key ||= OpenSSL::PKey.read(admin_client.get_admin_public_key(Voter.config.administrator_public_key_uri))
  end

  def digest(message)
    OpenSSL::Digest::SHA224.hexdigest(message)
  end

  def rsa
    @rsa ||= OnlineVoting::RSABlindSigner.new
  end

  def generate_key
    @generated_key ||= OpenSSL::PKey::RSA.new(512)
  end
end
