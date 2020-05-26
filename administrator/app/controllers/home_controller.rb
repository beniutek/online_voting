class HomeController < ApplicationController
  def public_key
    render json: { key: Administrator.config.public_key }
  end
end
