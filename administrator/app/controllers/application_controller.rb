class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def admin_phase_finished?
    !::Configuration.find_by(name: "admin_phase")&.data["on"]
  rescue StandardError => e
    pp e.message
    pp e.backtrace
    false
  end
end
