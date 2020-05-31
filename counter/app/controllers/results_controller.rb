class ResultsController < ApiController
  def index
    render json: Result.get_results
  end
end
