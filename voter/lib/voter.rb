module Voter
  extend self

  def config
    Rails.application.config.voter
  end
end
