class VotersController < ApplicationController
  def sign
    x = VoteSigner.new(params).sign
    response_json = {
    }
    render json: response_json
  end

  def response_json
    []
  end
end
