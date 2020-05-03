class VotesController < ApplicationController
  def sign
    binding.pry
    result = DataSigner.new(private_key: nil, message: message).sign
    key = result[1]
    admin_response = AdminClient.new.get_admin_signature(voter_id, result[2], result[3], key.public_key)
    response = CounterClient.new.send_vote(result[2], admin_response[:signed_message])
    render json: response
  end

  private

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
