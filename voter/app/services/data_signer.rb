require 'openssl'
require 'digest'

class DataSigner
  attr_reader :message

  def initialize(private_key: nil)
    @private_key = private_key
  end

  def sign_vote(message, voter_id)
    commitment, bit_commitment_key, iv = bit_commitment(message)
    encoded_commitment = Base64.encode64(commitment)
    blinded, r = rsa.blind(encoded_commitment, admin_key)
    blinded_signed = rsa._sign(blinded, voter_key)

    if rsa.verify(signed: blinded_signed, message: blinded, key: voter_key)
      puts "\nFIRST STEP OKAY!\n"
    end

    admin_response = admin_client.get_admin_signature(voter_id, blinded, blinded_signed, voter_key.public_key.to_s)

    raise AdminSignatureError if admin_response.to_s == "" || admin_response['error']

    signed_by_a = admin_response['data']['admin_signature']

    if rsa.verify(signed: signed_by_a, message: blinded, key: admin_key)
      puts "\nADMIN MESSAGE IS OK\n"
    end

    signed_by_a_unblinded = rsa.unblind(signed_by_a, r, admin_key)
    msg_int = rsa.text_to_int(encoded_commitment)
    puts "VERYFING: #{msg_int}"
    if rsa.verify(signed: signed_by_a_unblinded, message: msg_int, key: admin_key)
      puts "\n UNBLINDED SINGED IS VERIFIED!\n"
    end

    result = DataSignerResult.new
    result.bit_commitment =  encoded_commitment
    result.blinded_message = blinded
    result.blinded_signed_message = signed_by_a
    result.r = r
    result.voter_signature_key = voter_key
    result.bit_commitment_key = bit_commitment_key
    result.bit_commitment_iv = Base64.encode64(iv)
    result
  end

  def bit_commitment(message)
    cipher = OpenSSL::Cipher::AES256.new :CBC
    cipher.encrypt
    iv = cipher.random_iv
    random_key = SecureRandom.hex(16)
    cipher.key = random_key

    encrypted_text = cipher.update(message) + cipher.final
    [
      encrypted_text,
      random_key,
      iv,
    ]
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
