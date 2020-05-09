require 'openssl'
require 'digest'

class DataSigner
  attr_reader :key, :message

  def initialize(message: nil, private_key: nil)
    @private_key = private_key
    @message = message
  end

  def sign
    bit_commitment = generate_bit_commitment(message)
    salt, blinded_message = blind_message(bit_commitment)
    signed_message = sign_message(blinded_message)

    {
      salt: salt,
      private_key: key,
      bit_commitment: bit_commitment,
      blinded_message: blinded_message,
      signed_message: signed_message
    }
  end

  private

  def generate_bit_commitment(message)
    key.private_encrypt(message)
  end

  def blind_message(message)
    salt = OpenSSL::Random.random_bytes(256)
    blinded_message = Digest::SHA256.hexdigest("#{salt}.#{message}")
    [salt, blinded_message]
  end

  def sign_message(message)
    key.sign(OpenSSL::Digest::SHA256.new, message)
  end

  def key
    @key ||= @private_key ? OpenSSL::PKey.read(@private_key) : generate_key
  end

  def generate_key
    @generated_key ||= OpenSSL::PKey::RSA.new(2048)
  end
end
