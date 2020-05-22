class VotersController < ApplicationController
  def sign
    signature = VoteSigner.new(data: blinded_data_param, signature: signature_param, public_key: public_key_param, voter_id: voter_id_param).sign

    response_json = {}

    if signature
      response_json = {
        data: {
          voter_id: voter_id_param,
          admin_signature: signature.to_i,
          original_message: blinded_data_param,
          public_key: Administrator.config.public_key,
        }
      }
    end

    if response_json.empty?
      render json: {
        error: "you're not allowed to vote"
      }, status: 403
    else
      render json: response_json, status: 200
    end
  end

  def public_key
    render json: { key: Administrator.config.public_key }
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
