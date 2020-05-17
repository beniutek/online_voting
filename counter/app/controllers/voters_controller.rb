class VotesController < ApplicationController
  def index
    render json: vote_service.all_accounted_for_votes
  end

  def create
    response = vote_service.count_vote(signature: signature_param, message: message_param)

    render json: responsee
  end

  private

  def vote_service
    @vote_service ||= VoteService.new
  end

  def signature_param
    params[:admin_signature]
  end

  def message_param
    params[:bit_commitment]
  end
end
