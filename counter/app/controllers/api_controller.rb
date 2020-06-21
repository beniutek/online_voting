class ApiController < ActionController::API
  def admin_phase_finished?
    response = OnlineVoting::AdminClient.new.get_election_info
    !response["elections"]["admin_phase"]
  rescue StandardError => e
    pp e
    false
  end
end
