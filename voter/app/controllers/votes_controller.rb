class VotesController < ApplicationController
  def sign
    response = DataSigner.new(private_key: key, message: message).sign
    render json: response
  end

  private

  def key
    params[:data][:key]
  end

  def message
    params[:data][:message]
  end
end
