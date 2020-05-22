class VotesController < ApiController
  def index
    render json: vote_service.all_accounted_for_votes
  end

  def create
    valid, index = vote_service.count_vote(signature: signature_param, message: message_param)
    if valid
      render json: {
        index: index,
        bit_commitment: message_param,
        signature: signature_param
      }
    else
      render json: {}, status: 400
    end
  end

  private

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
