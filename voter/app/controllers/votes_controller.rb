=begin
 Votes controller is responsible for handling requests made to /votes
 Full API documentation can be found on:
 == {apiary}[https://voterprojectpi.docs.apiary.io]
=end

class VotesController < ApplicationController
  def sign
    result = data_signer.sign_vote(message, voter_id)
    unblinded_signed_message = data_signer.unblind_message(result.blinded_signed_message, result.r)

    counter_response = CounterClient.new.send_vote(unblinded_signed_message, result.bit_commitment)

    if counter_response.empty? || counter_response['error']
      render json: { error: "counter couldn't register your vote", details: counter_response }, status: 400
    else
      render json: {
        data: result.to_h.merge(unblinded_message_signed_by_admin: unblinded_signed_message.to_s, vote_index: counter_response["index"])
      }, status: 200
    end
  rescue CounterClient::CounterClientError => e
    puts "Exception: #{e.message}"
    render json: { error: "counter returned a bad response" }, status: 400
  rescue DataSigner::AdminSignatureError => e
    puts "Exception: #{e.message}"
    render json: { error: "admin signature could not be obtained" }, status: 400
  rescue StandardError => e
    puts "Exception: #{e.message}"
    render json: { error: e.message }, status: 400
  end

  private

  def vote
    @vote ||= data_signer.sign_vote(message, voter_id)
  end

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
