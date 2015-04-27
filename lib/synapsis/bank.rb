class Synapsis::Bank
  include Synapsis::Utilities

  module AccountClass
    PERSONAL = 1
    BUSINESS = 2
  end

  module AccountType
    CHECKING = 1
    SAVINGS = 2
  end

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
    added_bank = Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url "#{API_V2_PATH}bank/add/"
      req.body = build_json_from_variable_hash
    end

    if JSON.parse(added_bank.body)['success']
      Synapsis::RetrievedBank.new(added_bank)
    else
      Synapsis::Error.new(JSON.parse(added_bank.body))
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

    if JSON.parse(new_bank.body)['success']
      Synapsis::RetrievedBank.new(new_bank)
    else
      Synapsis::Error.new(JSON.parse(new_bank.body))
    end
  end

  def self.remove(bank_id, oauth_consumer_key)
    return Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url "#{API_V2_PATH}bank/delete/"
      req.body = JSON.generate(
        bank_id: bank_id,
        oauth_consumer_key: oauth_consumer_key
      )
    end
  end

  def view_linked_banks
    Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url "#{API_V2_PATH}bank/show/"
      req.body = build_json_from_variable_hash
    end
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

    if parsed_response['banks']
      parsed_response['banks'].first.each do |k, v|
        send("#{k}=", v)
      end
    elsif parsed_response['bank']
      parsed_response['bank'].each do |k, v|
        send("#{k}=", v)
      end
    end
  end
end
