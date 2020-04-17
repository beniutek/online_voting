class VotesController < ApplicationController
  def sign
    result = DataSigner.new(private_key: key, message: message).sign
    admin_response = AdminClient.new.get_admin_signature(voter_id, result[2], result[3])
    response = CounterClient.new.send_vote(result[2], admin_response[:signed_message])
    render json: response
  end

  private

  def key
    params[:data][:key]
  end

  def message
    params[:data][:message]
  end

  def voter_id
    params[:data][:id]
  end

  def serialize_signed_data(salt, pkey, bit_commitment, signed_message)
    {
      salt: salt,
      bit_commitment: bit_commitment,
      message: message,
      signed_message: signed_message,
      key: pkey
    }
  end
end
