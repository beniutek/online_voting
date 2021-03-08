class ApiController < ActionController::API
  def voting_phase
    return @voting_phase if @voting_phase
    response = OnlineVoting::AdminClient.new.get_election_info
     @voting_phase = response["elections"]
  rescue StandardError => e
    pp e
    {}
  end
end
