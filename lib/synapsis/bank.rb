class Synapsis::Bank
  include Synapsis::Utilities

  attr_accessor :account_class,
    :account_num,
    :account_type,
    :bank,
    :fullname,
    :mfa,
    :nickname,
    :oauth_consumer_key,
    :password,
    :pin,
    :routing_num,
    :username,
    :access_token

  def self.add(params)
    self.new(params).add
  end

  def self.link(params)
    self.new(params).link
  end

  def self.view_linked_banks(params)
    self.new(params).view_linked_banks
  end

  def initialize(params)
    params.each do |k, v|
      send("#{k}=", v)
    end
  end

  def add
    Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url "#{API_V2_PATH}bank/add/"
      req.body = build_json_from_variable_hash
    end
  end

  def link
    partially_linked_bank = Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url "#{API_V2_PATH}bank/login/?is_dev=yes"
      req.body = build_json_from_variable_hash
    end

    @access_token = JSON.parse(partially_linked_bank.body)['response']['access_token']

    new_bank =  Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url "#{API_V2_PATH}bank/mfa/?is_dev=yes"
      req.body = build_json_from_variable_hash
    end

    return Synapsis::RetrievedBank.new(new_bank)
  end

  def view_linked_banks
    Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url "#{API_V2_PATH}bank/show/"
      req.body = build_json_from_variable_hash
    end
  end

  class Synapsis::RetrievedBank
    attr_accessor :account_class,
      :account_number_string,
      :account_type,
      :address,
      :balance,
      :bank_name,
      :date,
      :email,
      :id,
      :is_active,
      :is_buyer_default,
      :is_seller_default,
      :is_verified,
      :mfa_verifed,
      :name_on_account,
      :nickname,
      :phone_number,
      :resource_uri,
      :routing_number_string

    def initialize(synapse_response)
      parsed_response = JSON.parse(synapse_response.body)

      parsed_response['banks'].first.each do |k, v|
        send("#{k}=", v)
      end
    end
  end
end
