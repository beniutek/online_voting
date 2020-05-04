class VotersController < ApplicationController
  def sign
    signature = VoteSigner.new(data: blinded_data_param, signature: signature_param, public_key: public_key_param).sign
    response_json = {
      data: {
        voter_id: voter_id_param,
        signature: signature,
        message: blinded_data_param
      }
    }

    render json: response_json
  end

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
