class VoteService
  def initialize(client: OnlineVoting::AdminClient.new)
    @client = client
  end

  def count_vote(signature:, message:)
    admin_public_key = Counter.config.admin_public_key

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
