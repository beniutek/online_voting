require 'openssl'
require 'digest'

class DataSigner
  attr_reader :key, :message

  def initialize(message: nil, private_key: nil)
    @private_key = private_key
    @message = message
  end

  def sign
    salt, bit_commitment = generate_bit_commitment(message)
    signed_message = sign_message(bit_commitment)
    [salt, key, bit_commitment, signed_message]
  end

  private

  def generate_bit_commitment(message)
    salt = OpenSSL::Random.random_bytes(256)
    bit_commitment = Digest::SHA256.hexdigest("#{salt}.#{message}")
    [salt, bit_commitment]
  end

  def sign_message(message)
    key.sign(OpenSSL::Digest::SHA256.new, message)
  end

  def key
    @key ||= @private_key ? OpenSSL::PKey.read(@private_key) : generated_key
  end

  def generated_key
    @generated_key ||= OpenSSL::PKey::RSA.new(2048)
  end
end
