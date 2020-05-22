class VotesController < ApplicationController
  def sign
    blinded, blinded_signed_message, r, voter_key, bit_commitment = data_signer.sign_vote(message, voter_id)
    unblinded_signed_message = data_signer.unblind_message(blinded_signed_message, r)
    counter_response = CounterClient.new.send_vote(unblinded_signed_message, bit_commitment)
    if counter_response.empty?
      render json: { error: "counter couldn't register your vote" }, status: 400
    else
      render json: {
        data: {
          key: voter_key.to_s,
          blidning_factor: r,
          bit_commitment: bit_commitment,
          blinded_message_signed_by_admin: blinded_signed_message,
          unblinded_message_signed_by_admin: unblinded_signed_message,
          index: counter_response["data"]["index"],
        }
      }
    end
  rescue DataSigner::AdminSignatureError => e
    puts "Exception: #{e.message}"
    render json: { error: "admin signature could not be obtained" }, status: 400
  end

  private

  def data_signer
    @data_signer ||= DataSigner.new(private_key: nil)
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
