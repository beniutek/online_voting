class ResultsController < ApiController
  def index
    render json: Result.first
  end
end
