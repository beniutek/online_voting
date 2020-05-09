class VotesController < ApplicationController
  def sign
    result = DataSigner.new(private_key: nil, message: message).sign
    key = result[:private_key]
    puts "DATA SIGNER: "
    result.each do |key, val|
      puts "#{key} : #{val}"
      puts ""
    end
    admin_response = AdminClient.new.get_admin_signature(voter_id, result[:blinded_message], result[:signed_message], key.public_key.to_s)
    # response = CounterClient.new.send_vote(result[2], admin_response[:signed_message])
    puts "ADMIN RESP"
    JSON.parse(admin_response)["data"].each do |key, val|
      puts "#{key} : #{val}"
      puts " "
    end

    puts "========="

    orig = JSON.parse(admin_response)["data"]["original_message"]
    decoded = Base64.decode64(orig)
    puts "DECODED: "
    puts decoded
    puts "=="
    puts decoded == result[:signed_message]
    puts orig == result[:bit_commitment]
    render json: admin_response
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
