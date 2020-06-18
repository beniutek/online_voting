# == Schema Information
#
# Table name: candidates
#
#  id          :bigint           not null, primary key
#  uuid        :uuid             not null
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Candidate < ApplicationRecord
end
