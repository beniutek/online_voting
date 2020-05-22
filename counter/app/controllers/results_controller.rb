class ResultssController < ApplicationController
  def index
    render json: Result.first
  end
end
