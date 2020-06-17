=begin
  This class represents a client that can make requests and receive response from the counter module
=end

class CounterClient
  #
  # == Parameters:
  # client::
  #  Basically an object that is able to make post requests, RestClient by default
  # uri::
  #  string
  # == Returns:
  # a new CounterClient instance
  def initialize(client = RestClient, uri = Voter.config.counter_module_uri)
    @client = client
    @uri = uri
  end

  #
  # == Parameters:
  # signed_message::
  #  Any kind of string, represents a bit commitment that was signed by administrator module
  # bit_commitment::
  #  Any kind of string, represents the commitment user made about the poll
  # == Returns:
  # response object that has `body` method
  # == Raises:
  # CounterClientError
  def send_vote(signed_message, bit_commitment)
    values = {
      signed_message: signed_message,
      bit_commitment: bit_commitment,
    }
    headers = {}
    response = @client.post(@uri, values, headers)

    JSON.parse(response.body)
  rescue StandardError => e
    raise CounterClientError(e.message)
  end

  class CounterClientError < StandardError
  end
end
