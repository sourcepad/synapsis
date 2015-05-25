class Synapsis::User < Synapsis::APIResource
  include Synapsis::Utilities
  extend Synapsis::APIOperations::Create
  extend Synapsis::APIOperations::Edit
  extend Synapsis::APIOperations::View

  def self.create(params)
    response = create_request(params.merge(client_credentials))
    return_response(response)
  end

  def self.edit(params)
    response = edit_request(params)
    return_response(response)
  end

  def self.view(oauth_token)
    response = view_request('oauth_consumer_key' => oauth_token)
    return_response(response)
  end

  def self.refresh(params)
    response = request(:post, refresh_url, params.merge(client_credentials))
    return_response(response)
  end

  def self.view_linked_banks(oauth_token)
    Synapsis::Bank.view_linked_banks(oauth_token)
  end

  private

  def self.client_credentials
    {
      client_id: Synapsis.client_id,
      client_secret: Synapsis.client_secret
    }
  end

  def self.create_url
    "#{API_V2_PATH}user/create/"
  end

  def self.refresh_url
    "#{API_V2_PATH}user/refresh"
  end
end

