require 'openssl'
require 'digest'

# DataSigner is responsible for handling messages.
# This includes encryption, blinding, signing the message by admin module and veryfing the correctness of the message
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
  def initialize(private_key: nil, encryptor: OnlineVoting::Crypto::Message, signer: OnlineVoting::RSABlindSigner, admin_client: OnlineVoting::AdminClient)
    @signer_class = signer
    @private_key = private_key
    @encryptor = encryptor
    @signer = signer
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
    admin_signer = @signer.new(admin_key)
    voter_signer = @signer.new(voter_key)

    encrypted_msg, msg_key, iv = @encryptor.encrypt(message.to_json, key, iv)
    encoded_encrypted_msg = Base64.encode64(encrypted_msg)
    blinding_factor = admin_signer.generate_blinding_factor
    blinded_encoded_encrypted_msg = admin_signer.blind(encoded_encrypted_msg, blinding_factor)

    voter_signed_blinded_encoded_encrypted_msg = voter_signer.sign(blinded_encoded_encrypted_msg)

    admin_response = admin_client.get_admin_signature(
      voter_id,
      blinded_encoded_encrypted_msg,
      voter_signed_blinded_encoded_encrypted_msg,
      voter_key.public_key.to_s)

    raise AdminSignatureError if admin_response.to_s == "" || admin_response['error']

    admin_signed_blinded_encoded_encrypted_msg = admin_response['data']['admin_signature']

    if !admin_signer.verify(signed: admin_signed_blinded_encoded_encrypted_msg, message: blinded_encoded_encrypted_msg)
      raise AdminSignatureError.new("admin signature invalid")
    end

    msg_int = admin_signer.str_to_int(encoded_encrypted_msg)
    DataSignerResult.new(msg_int, blinded_encoded_encrypted_msg, admin_signed_blinded_encoded_encrypted_msg, blinding_factor, voter_key.to_s, msg_key, Base64.encode64(iv))
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
    admin_signer = @signer.new(signing_key)
    unblinded_signed_message = admin_signer.unblind(signed_message, r)
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
    admin_signer = @signer.new(signing_key)
    msg_int = admin_signer.text_to_int(message)
    admin_signer.verify(signed: signed_message, message: msg_int)
  end

  #
  # This error is thrown if admin returns an empty/error message or
  # if we detect that the signed message doesn't match with the message that we have sent
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

  def generate_key
    @generated_key ||= OpenSSL::PKey::RSA.new(512)
  end
end
