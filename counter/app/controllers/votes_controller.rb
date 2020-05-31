class VotesController < ApiController
  def index
    render json: vote_service.all_votes.map { |x| VoteSerializer.new(x).to_h }
  end

  def create
    valid, i = vote_service.count_vote(signature: signature_param, message: message_param)
    if valid
      render json: {
        index: i,
        bit_commitment: message_param,
        signature: signature_param
      }
    else
      render json: {
        error: i,
      }, status: 400
    end
  end

  def open
    if vote_service.open_vote(params[:id], params[:data][:key], params[:data][:iv])
      render json: {}, status: 200
    else
      render json: {}, status: 400
    end
  end

  private

  def blinding_factor_param
    params[:r]
  end

  def vote_service
    @vote_service ||= VoteService.new
  end

  def signature_param
    params[:signed_message]
  end

  def message_param
    params[:bit_commitment]
  end
end
