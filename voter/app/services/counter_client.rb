class CounterClient
  def initialize(client = RestClient, uri = VoterApp.config.counter_module_uri)
    @client = client
    @uri = uri
  end

  def send_vote(bit_commitment, signed_message)
    values = {
      signed_message: signed_message,
      bit_commitment: bit_commitment,
    }
    headers = {}
    @client.post(@uri, values, headers)
  rescue StandarError => e
    puts "some shenaningans happening while sending request to counter: "
    puts e.message
    puts "FIN"
    {}
  end
end
