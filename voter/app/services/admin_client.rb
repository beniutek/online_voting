require 'rest_client'

class AdminClient
  def initialize(client = RestClient, uri = Voter.config.administrator_module_uri)
    @client = client
    @uri = uri
  end

  def get_admin_signature(voter_id, bit_commitment, signed_message, public_key)
    values = {
      data: {
        voter_id: voter_id,
        signature: signed_message,
        message: bit_commitment,
        public_key: public_key,
      }
    }
    headers = {}
    @client.post(@uri, values, headers)
  rescue StandardError => e
    puts "some shenaningans happening while sending request to admin: "
    puts e.message
    puts "FIN"
    {}
  end
end
