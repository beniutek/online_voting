=begin
 Votes controller is responsible for handling requests made to /votes
 Full API documentation can be found on:
 == {apiary}[https://counter4.docs.apiary.io/]
=end

class VotesController < ApiController
  def index
    if voting_phase["admin_phase"]
      render json: { error: 'admin phase is not finished yet' }, status: 400
    elsif voting_phase["casting_phase"]
      render json: { error: 'casting phase is not finished yet' }, status: 400
    else
      render json: vote_service.all_votes.map { |x| VoteSerializer.new(x).to_h }
    end
  rescue StandardError => e
    render json: { error: "Error: Results unavailable" }
  end

  def create
    if signature_param && message_param
      valid, i = vote_service.count_vote(signature: signature_param, message: message_param)
      if valid
        render json: {
          index: i,
          bit_commitment: message_param,
          signature: signature_param
        }
      else
        render json: { error: i }, status: 400
      end
    else
      render json: { error: 'missing params' }, status: 400
    end
  end

  def open
    if vote_service.open_vote(params[:id], params[:data][:key], params[:data][:iv])
      render json: { data: { description: 'vote opened!'} }, status: 200
    else
      render json: {}, status: 400
    end
  rescue StandardError => e
    render json: { error: 'something went wrong' }, status: 400
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
