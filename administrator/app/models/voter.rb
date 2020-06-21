# == Schema Information
#
# Table name: voters
#
#  id             :bigint           not null, primary key
#  voter_id       :string           not null
#  public_key     :string
#  signature      :string
#  data           :string
#  signed_vote_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Voter < ApplicationRecord
  scope :has_voted, -> { where.not(signature: nil) }

  def allowed_to_vote?
    signed_vote_at.nil?
  end
end
