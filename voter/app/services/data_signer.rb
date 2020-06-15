require 'openssl'
require 'digest'

class DataSigner
  def initialize(private_key: nil, encryptor: OnlineVoting::Crypto::Message, signer: OnlineVoting::Crypto::BlindSigner)
    @signer = signer.new
    @private_key = private_key
    @encryptor = encryptor
  end

  def sign_vote(message, voter_id)
    encrypted_msg, msg_key, iv = @encryptor.encrypt(message.to_json)
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

    puts "\nVERYFING : #{msg_int}"

    if rsa.verify(signed: admin_signed_encoded_encrypted_msg, message: msg_int, key: admin_key)
      puts "\n UNBLINDED SINGED IS VERIFIED!\n"
    else
      raise StandardError.new("unblinded signature invalid")
    end

    DataSignerResult.new(msg_int, blinded_encoded_encrypted_msg, admin_signed_blinded_encoded_encrypted_msg, r, voter_key, msg_key, Base64.encode64(iv))
  end

  def digest(message)
    OpenSSL::Digest::SHA224.hexdigest(message)
  end

  def unblind_message(signed_message, r, signing_key = admin_key)
    unblinded_signed_message = rsa.unblind(signed_message, r, signing_key)
  end

  def verify(signed_message, message, signing_key = admin_key)
    msg_int = rsa.text_to_int(message)
    rsa.verify(signed: signed_message, message: msg_int, key: signing_key)
  end

  def rsa
    @rsa ||= OnlineVoting::RSABlindSigner.new
  end

  def admin_client
    @admin_client ||= OnlineVoting::AdminClient.new(uri: Voter.config.administrator_module_uri)
  end

  def admin_key
    @admin_key ||= OpenSSL::PKey.read(admin_client.get_admin_public_key(Voter.config.administrator_public_key_uri))
  end

  def voter_key
    @voter_key ||= @private_key ? OpenSSL::PKey.read(@private_key) : generate_key
  end

  def generate_key
    @generated_key ||= OpenSSL::PKey::RSA.new(512)
  end

  class AdminSignatureError < StandardError
  end
end
