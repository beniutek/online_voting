class VoteService
  def initialize
    @
  end

  def count_vote(signature:, message:)
  end

  def all_accounted_for_votes
    admin_repsonse = JSON.parse(AdminClient.new.admin_voters_list)
    admin_registered_votes = admin_response["data"].size

    if Counter.config.strict_votes_count
      return Voter.count == admin_registered_votes
    else
      return Voter.count <= admin_registered_votes
    end
  end
end
