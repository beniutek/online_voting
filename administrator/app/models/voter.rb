class Voter < ApplicationRecord
  def self.allowed_to_vote?(vid)
    voter = Voter.find_by(voter_id: vid)

    return false unless voter

    voter.allowed_to_vote?
  end

  def allowed_to_vote?
    signed_vote_at.nil?
  end
end
