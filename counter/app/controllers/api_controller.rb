class ApiController < ActionController::API
  def admin_phase?
    response = OnlineVoting::AdminClient.new.get_election_info
    pp '-----------response---------------------'
    pp response["elections"]["admin_phase"]
    pp '----------------------------------------'
    x = !!response["elections"]["admin_phase"]
    pp '-------- admin phase finished?=---------'
    pp x
    pp '----------------------------------------'
  rescue StandardError => e
    pp e
    false
  end
end
