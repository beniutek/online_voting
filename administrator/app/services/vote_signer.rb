require 'openssl'

class VoteSigner
  def initialize(data:, signature:, public_key:, voter_id:)
    @data = data
    @pkey = public_key
    @signature = signature
    @voter_id = voter_id
  end

  def sign
    raise StandardError unless validate_data(@data, @signature, @pkey)
    voter = Voter.find_by(voter_id: @voter_id)

    if false # voter.signed_vote_at
      raise StandardError
    else
      voter.update(signed_vote_at: Time.now)
      admin_key = OpenSSL::PKey.read(Administrator.config.online_voting_secret)
      admin_key.sign(OpenSSL::Digest::SHA256.new, @data)
    end
  rescue ActiveRecord::RecordNotFound => e
    puts "voter not found! #{@voter_id}"
  end

  private

  def validate_data(data, signature, pkey)
    key = OpenSSL::PKey.read(pkey)
    key.verify(OpenSSL::Digest::SHA256.new, signature, data)
  end
end
