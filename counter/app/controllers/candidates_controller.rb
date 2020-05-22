class CandidatesController < ApiController
  def index
    render json: Candidate.all
  end
end
