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
    Voter.find_by(voter_id: @voter_id).update(signed_vote_at: Time.now)
    admin_key = OpenSSL::PKey.read(Administrator.config.online_voting_secret)
    signed_message = admin_key.sign(OpenSSL::Digest::SHA256.new, @data)
  rescue ActiveRecord::RecordNotFound => e
    puts "voter not found! #{@voter_id}"
  end

  private

  def validate_data(data, signature, pkey)
    key = OpenSSL::PKey.read(pkey)
    key.verify(OpenSSL::Digest::SHA256.new, signature, data)
  end
end
