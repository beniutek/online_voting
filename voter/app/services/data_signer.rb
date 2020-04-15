require 'openssl'

class DataSigner
  def initialize(message: nil, private_key: nil)
    @private_key = private_key
    @message = message
  end

  def sign
    signature = key.sign(OpenSSL::Digest::SHA256.new, @message)

    {
      private_key: key.to_s,
      public_key: key.public_key.to_s
      message: message,
      signature: signature
    }
  end

  private

  def key
    @key ||= @private_key ? OpenSSL::PKey.read(@private_key) : generated_key
  end

  def generated_key
    @generated_key ||= OpenSSL::PKey::RSA.new(2048)
  end
end
