class ApplicationController < ActionController::Base
  def admin_phase_finished?
    !!::Configuration.find_by(name: "admin_phase")&.data["on"]
  rescue StandardError => e
    pp e
    false
  end
end
