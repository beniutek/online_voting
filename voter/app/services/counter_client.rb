class CounterClient
  def initialize(client = RestClient, uri = Voter.config.counter_module_uri)
    @client = client
    @uri = uri
  end

  def send_vote(signed_message, bit_commitment)
    values = {
      signed_message: signed_message,
      bit_commitment: bit_commitment,
    }
    headers = {}
    response = @client.post(@uri, values, headers)
    JSON.parse(response.body)
  rescue StandardError => e
    puts "some shenaningans happening while sending request to counter: "
    puts e.message
    puts "FIN"
    {}
  end
end
