require 'openssl'

class VoteSigner
  def initialize(data:, signature:, public_key:)
    @data = data
    @pkey = public_key
    @signature = Base64.decode64(signature)
  end

  def sign
    raise StandardError unless validate_data(@data, @signature, @pkey)

    admin_key = OpenSSL::PKey.read(Administrator.config.online_voting_secret)
    signed_message = admin_key.sign(OpenSSL::Digest::SHA256.new, @data)
    Base64.encode64(signed_message)
  end

  private

  def validate_data(data, signature, pkey)
    key = OpenSSL::PKey.read(pkey)
    key.verify(OpenSSL::Digest::SHA256.new, signature, data)
  end
end
