require 'openssl'
require 'digest'

class DataSigner
  attr_reader :message

  def initialize(private_key: nil)
    @private_key = private_key
  end

  def sign_vote(message, voter_id)
    commitment = bit_commitment(message)
    blinded, r = rsa.blind(commitment, admin_key)
    blinded_signed = rsa._sign(blinded, voter_key)

    admin_response = admin_client.get_admin_signature(voter_id, blinded, blinded_signed, voter_key.public_key.to_s)

    raise AdminSignatureError if admin_response.to_s == "" || admin_response['error']

    signed_by_a = admin_response['data']['admin_signature']

    [
      blinded,
      admin_response['data']['admin_signature'],
      r,
      voter_key,
      rsa.text_to_int(commitment)
    ]
  end

  def bit_commitment(message)
    digest(message)
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
