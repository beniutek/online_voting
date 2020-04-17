require 'rest_client'

class AdminClient
  def initialize(client = RestClient, uri = VoterApp.config.administrator_module_uri)
    @client = client
    @uri = uri
  end

  def get_admin_signature(voter_id, bit_commitment, signed_message, public_key)
    values = {
      voter_id: voter_id,
      signed_message: signed_message,
      bit_commitment: bit_commitment,
      public_key: public_key,
    }
    headers = {}
    @client.post(@uri, values, headers)
  rescue StandarError => e
    puts "some shenaningans happening while sending request to admin: "
    puts e.message
    puts "FIN"
    {}
  end
end
