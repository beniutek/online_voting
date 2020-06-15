require 'rest_client'

module OnlineVoting
  PUBLIC_KEY_URI = 'http://localhost:3030/public-key'
  ELECTION_INFO_URI = 'http://localhost:3030/election-info'
  VOTERS_URI = 'http://localhost:3030/voters'

  class AdminClient
    def initialize(client: RestClient, uri: nil)
      @client = client
      @uri = uri
    end

    def get_admin_public_key(uri = PUBLIC_KEY_URI)
      response = @client.get(uri)
      JSON.parse(response)['key']
    end

    def get_election_info(uri = ELECTION_INFO_URI)
      repsonse = @client.get(uri)
      JSON.parse(response)
    end

    def get_admin_signature(voter_id, message, signed_message, public_key, uri = VOTERS_URI)
      values = {
        data: {
          voter_id: voter_id,
          message: message,
          signature: signed_message,
          public_key: public_key,
        }
      }
      headers = {}

      response = @client.post(uri, values, headers)

      JSON.parse(response)
    rescue StandardError => e
      puts "some shenaningans happening while sending request to admin: "
      puts e.message
      puts "FIN"
      ""
    end

    def admin_voters_list
      headers = {}
      @client.get(@uri, headers)
    end
  end
end
