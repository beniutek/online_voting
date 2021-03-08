class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def admin_phase?
    ::Configuration.find_by(name: "admin_phase").active
  rescue StandardError
    false
  end
end
