class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def admin_phase?
    pp "----------------admin_phase_on?---------------"
    x = !!::Configuration.find_by(name: "admin_phase")&.data["on"]
    pp x
    pp "----------------------------------------------"
    x
  rescue StandardError => e
    pp e.message
    pp e.backtrace
    false
  end
end
