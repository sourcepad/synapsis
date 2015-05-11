class Synapsis::User < Synapsis::APIResource
  include Synapsis::Utilities
  extend Synapsis::APIOperations::Edit
  extend Synapsis::APIOperations::View

  attr_accessor :access_token,
    :oauth_consumer_key,
    :expires_in,
    :reason,
    :refresh_token,
    :success,
    :username,
    :user_id,
    :user,
    :accept_bank_payments, # params from an edit
    :accept_gratuity,
    :balance,
    :email,
    :fullname,
    :has_avatar,
    :is_seller,
    :phone_number,
    :resource_uri,
    :seller_details,
    :settle_daily,
    :username,
    :visit_count,
    :visit_message

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

  def initialize(synapse_response)
    synapse_response.each do |k, v|
      send("#{k}=", v)
    end

    if synapse_response['user']
      synapse_response['user'].each do |k, v|
        send("#{k}=", v)
      end
    end
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
end

