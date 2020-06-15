class HomeController < ApplicationController
  def public_key
    render json: { key: Administrator.config.public_key }
  end

  def phase
    render json: {
      elections: {
        start: Administrator.config.election_start,
        end: Administrator.config.election_end
      }
    }
  end
end
