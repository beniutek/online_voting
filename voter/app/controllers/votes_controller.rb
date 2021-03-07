=begin
 Votes controller is responsible for handling requests made to /votes
 Full API documentation can be found on:
 == {apiary}[https://voterprojectpi.docs.apiary.io]
=end

class VotesController < ApplicationController
  def sign
    if message && voter_id
      result = data_signer.sign_vote(message, voter_id)
      unblinded_signed_message = data_signer.unblind_message(result.blinded_signed_message, result.r)

      counter_response = CounterClient.new.send_vote(unblinded_signed_message, result.bit_commitment)

      if counter_response.empty? || counter_response['error']
        render json: { error: "counter couldn't register your vote", details: counter_response }, status: 400
      else
        render json: {
          data: result.to_h.merge(vote_index: counter_response["index"])
        }, status: 200
      end
    else
      render json: { error: 'empty params' }, status: :bad_request
    end
  rescue CounterClient::CounterClientError => e
    render json: { error: "counter returned a bad response" }, status: 400
  rescue DataSigner::AdminSignatureError => e
    render json: { error: "admin signature could not be obtained" }, status: 400
  rescue StandardError => e
    e.backtrace.each do |l| pp l end
    render json: { error: e.message }, status: 400
  end

  def open
    counter_response = CounterClient.new.open_vote(params[:data][:vote_index], params[:data][:bit_commitment_key], params[:data][:bit_commitment_iv])

    if counter_response.empty? || counter_response['error']
      render json: { error: "counter couldn't open your vote", details: counter_response }, status: 400
    else
      render json: { data: { description: 'vote succefully opened' } }, status: 200
    end
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
