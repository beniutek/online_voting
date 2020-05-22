require 'rest_client'

class AdminClient
  def initialize(client = RestClient, uri = Counter.config.administrator_module_uri)
    @client = client
    @uri = uri
  end

  def admin_voters_list
    headers = {}
    @client.get(@uri, headers)
  end
end
