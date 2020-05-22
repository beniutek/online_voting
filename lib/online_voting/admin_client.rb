require 'rest_client'

module OnlineVoting
  class AdminClient
    def initialize(client: RestClient, uri: nil)
      @client = client
      @uri = uri
    end

    def get_admin_public_key(uri = nil)
      response = @client.get(uri || @uri)
      JSON.parse(response)['key']
    end

    def get_admin_signature(voter_id, message, signed_message, public_key)
      values = {
        data: {
          voter_id: voter_id,
          message: message,
          signature: signed_message,
          public_key: public_key,
        }
      }
      headers = {}

      response = @client.post(@uri, values, headers)

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
