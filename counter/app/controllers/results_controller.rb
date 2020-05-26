class ResultsController < ApiController
  def index
    render json: Result.compute_results
  end
end
