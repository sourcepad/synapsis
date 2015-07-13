class Synapsis::User < Synapsis::APIResource
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

  def self.add_ssn(params)
    response = request(:post, add_ssn_url, params)

    # Synapse incorrectly returns SSN validation fails as 200. Thus we have to override default return_reponse behavior
    if parse_as_synapse_resource(response).success
      return_response(response)
    else
      raise Synapsis::Error, parse_as_synapse_resource(response).reason
    end
  end

  def self.verify(params)
    response = request(:post, verify_ssn_url, params)

    # Synapse incorrectly returns SSN validation fails as 200. Thus we have to override default return_reponse behavior
    if parse_as_synapse_resource(response).success
      return_response(response)
    else
      raise Synapsis::Error, parse_as_synapse_resource(response).reason
    end
  end

  def self.view_linked_banks(oauth_token)
    Synapsis::Bank.view_linked_banks(oauth_token)
  end

  def self.view_recent_orders(params)
    Synapsis::Order.view_recent_orders(params)
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

  def self.add_ssn_url
    "#{API_V2_PATH}user/ssn/add"
  end

  def self.verify_ssn_url
    "#{API_V2_PATH}user/ssn/answer"
  end
end

