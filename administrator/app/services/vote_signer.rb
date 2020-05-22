require 'openssl'

class VoteSigner
  def initialize(data:, signature:, public_key:, voter_id:)
    @data = data
    @pkey = public_key
    @signature = signature
    @voter_id = voter_id
  end

  def sign
    raise ValidationError unless validate_data(@data, @signature, @pkey)
    voter = Voter.find_by(voter_id: @voter_id)

    if voter.allowed_to_vote?
      voter.update(signed_vote_at: Time.now)
      rsa.sign(message: @data.to_i, key: admin_key)
    else
      raise ValidationError
    end
  rescue StandardError => e
    puts "Exception: #{e.message}"
    nil
  end

  private

  def rsa
    @rsa ||= OnlineVoting::RSABlindSigner.new
  end

  def admin_key
    @admin_key ||= OpenSSL::PKey.read(Administrator.config.online_voting_secret)
  end

  def validate_data(data, signature, pkey)
    key = OpenSSL::PKey.read(pkey)
    rsa.verify(message: data.to_i, signed: signature.to_i, key: key)
  end

  class ValidationError < StandardError
  end
end
