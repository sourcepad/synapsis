class Synapsis::User
  include Synapsis::Utilities

  attr_accessor :email,
    :fullname,
    :password,
    :ip_address,
    :phonenumber,
    :access_token,
    :refresh_token,
    :username

  def self.create(params)
    self.new(params).create
  end

  def self.view(params)
    self.new({}).view(params)
  end

  def initialize(params)
    params.each do |k, v|
      send("#{k}=", v)
    end
  end

  def create
    response = Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url "#{API_V2_PATH}user/create/"
      req.body = build_json_from_params
    end

    if response.success?
      update_attributes(response)
      return self
    else
      return response
    end
  end

  def view(oauth_token = @access_token)
    response = Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url "#{API_V2_PATH}user/show/"
      req.body = JSON.generate({ 'oauth_consumer_key' => oauth_token})
    end

    if response.success?
      return Synapsis::RetrievedUser.new(response)
    else
      return response
    end
  end

  private

  def update_attributes(synapse_response)
    parsed_response = JSON.parse(synapse_response.body)
    @fullname =  parsed_response['fullname']
    @access_token =  parsed_response['access_token']
    @refresh_token =  parsed_response['refresh_token']
    @username =  parsed_response['username']
  end

  class Synapsis::RetrievedUser
    attr_accessor :accept_bank_payments,
      :accept_gratuity,
      :balance,
      :email,
      :fullname,
      :has_avatar,
      :phone_number,
      :resource_uri,
      :seller_details,
      :user_id,
      :username,
      :visit_count,
      :visit_message

    def initialize(synapse_response)
      parsed_response = JSON.parse(synapse_response.body)

      parsed_response['user'].each do |k, v|
        send("#{k}=", v)
      end
    end
  end
end

