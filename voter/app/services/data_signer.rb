require 'openssl'
require 'digest'

class DataSigner
  attr_reader :message

  def initialize(private_key: nil)
    @private_key = private_key
  end

  def sign_vote(message, voter_id)
    puts "SIGNIGN MESSAGE: #{message}"

    encrypted_msg, msg_key, iv = encrypt(message)

    puts "\nCOMMITMENT: #{encrypted_msg}"

    encoded_encrypted_msg = Base64.encode64(encrypted_msg)

    puts "\nENCODED COMMITMENT: #{encoded_encrypted_msg}"

    blinded_encoded_encrypted_msg, r = rsa.blind(encoded_encrypted_msg, admin_key)

    puts "\nBLINDED #{blinded_encoded_encrypted_msg}"

    voter_signed_blinded_encoded_encrypted_msg = rsa._sign(blinded_encoded_encrypted_msg, voter_key)

    puts "\nBLINDED SIGNED: #{voter_signed_blinded_encoded_encrypted_msg}"

    if rsa.verify(signed: voter_signed_blinded_encoded_encrypted_msg, message: blinded_encoded_encrypted_msg, key: voter_key)
      puts "\nFIRST STEP OKAY!\n"
    else
      raise StandardError.new("really?")
    end

    admin_response = admin_client.get_admin_signature(
      voter_id,
      blinded_encoded_encrypted_msg,
      voter_signed_blinded_encoded_encrypted_msg,
      voter_key.public_key.to_s)

    raise AdminSignatureError if admin_response.to_s == "" || admin_response['error']

    admin_signed_blinded_encoded_encrypted_msg = admin_response['data']['admin_signature']

    binding.pry
    if rsa.verify(signed: admin_signed_blinded_encoded_encrypted_msg, message: blinded_encoded_encrypted_msg, key: admin_key)
      puts "\nADMIN MESSAGE IS OK\n"
    else
      raise StandardError.new("response from admin can't be verified")
    end

    admin_signed_encoded_encrypted_msg = rsa.unblind(admin_signed_blinded_encoded_encrypted_msg, r, admin_key)
    msg_int = rsa.text_to_int(encoded_encrypted_msg)

    puts "\nVERYFING : #{msg_int}"

    if rsa.verify(signed: admin_signed_encoded_encrypted_msg, message: msg_int, key: admin_key)
      puts "\n UNBLINDED SINGED IS VERIFIED!\n"
    else
      raise StandardError.new("unblinded signature invalid")
    end

    result = DataSignerResult.new(encrypted_msg, blinded_encoded_encrypted_msg, admin_signed_blinded_encoded_encrypted_msg, r, voter_key, msg_key, Base64.encode64(iv))
    # result.bit_commitment =  encoded_commitment
    # result.blinded_message = blinded
    # result.blinded_signed_message = signed_by_a
    # result.r = r
    # result.voter_signature_key = voter_key
    # result.bit_commitment_key = bit_commitment_key
    # result.bit_commitment_iv = Base64.encode64(iv)
    result
  end

  def encrypt(message)
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
