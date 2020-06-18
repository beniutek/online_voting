# == Schema Information
#
# Table name: votes
#
#  id             :bigint           not null, primary key
#  uuid           :uuid             not null
#  bit_commitment :string
#  signed_message :string
#  decoded        :jsonb
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Vote < ApplicationRecord

end
