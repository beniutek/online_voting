# == Schema Information
#
# Table name: results
#
#  id         :bigint           not null, primary key
#  result     :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# This probably is a very poor approach to presenting results.
# I'll be revising it in the future
#
class Result < ApplicationRecord
  #
  # == Returns:
  # a result object
  def self.get_results
    if Result.first
      Result.first.result
    else
      obj = Result.new
      candidates = Candidate.all
      results = Hash[candidates.collect { |i| [i.id, { desc: i.description, result: 0 }] }]
      Vote.all.each do |vote|
        candidate_id = vote.decoded['candidate'].to_i
        results[candidate_id][:result] = results[candidate_id][:result] + 1
      end

      obj.result = results
      obj.save!
      obj.result
    end
  end
end
