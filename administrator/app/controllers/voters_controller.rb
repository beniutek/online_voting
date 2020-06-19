=begin
 Voters controller is responsible for handling requests made to administrator module
 Full API documentation can be found on:
 == {apiary}[https://admin58.docs.apiary.io/]
=end
class VotersController < ApplicationController
  def index
    render json: Voter.all.map { |x| { id: x.voter_id, message: x.data, signature: x.signature } }
  end

  def create
    signature = VoteSigner.new(data: blinded_data_param, signature: signature_param, public_key: public_key_param, voter_id: voter_id_param).sign
    data = {
      voter_id: voter_id_param,
      admin_signature: signature.to_i,
      original_message: blinded_data_param,
      public_key: Administrator.config.public_key,
    }
    render json: { data: data }, status: 200
  rescue VoteSigner::SignatureValidationError => e
    render json: { error: "signature is invalid" }, status: 400
  rescue VoteSigner::ForbiddenToVoteError => e
    render json: { error: "you're not allowed to vote", status: 403 }, status: :forbidden
  end

  private

  def blinded_data_param
    params[:data][:message]
  end

  def signature_param
    params[:data][:signature]
  end

  def public_key_param
    params[:data][:public_key]
  end

  def voter_id_param
    params[:data][:voter_id]
  end
end
