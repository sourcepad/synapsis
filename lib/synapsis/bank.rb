class Synapsis::Bank < Synapsis::APIResource
  include Synapsis::Utilities
  extend Synapsis::APIOperations::Create

  module AccountClass
    PERSONAL = 1
    BUSINESS = 2
  end

  module AccountType
    CHECKING = 1
    SAVINGS = 2
  end

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

  def self.add(params)
    added_bank = create_request(params)
    return_response(added_bank)
  end

  def self.link(params)
    partially_linked_bank = Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url "#{API_V2_PATH}bank/login/?is_dev=yes"
      req.body = JSON.generate(params)
    end

    parsed_partially_linked_bank = parse_as_synapse_resource(partially_linked_bank)

    if parsed_partially_linked_bank.success
      if parsed_partially_linked_bank.banks # This happens if the added bank has no MFA
        return parsed_partially_linked_bank
      end

      @access_token = parsed_partially_linked_bank.response.access_token

      new_bank =  Synapsis.connection.post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.url "#{API_V2_PATH}bank/mfa/?is_dev=yes"
        req.body = JSON.generate(params.merge(access_token: @access_token))
      end

      parsed_new_bank = parse_as_synapse_resource(new_bank)

      if parsed_new_bank.banks
        return parsed_new_bank
      else
        raise Synapsis::Error, 'Wrong MFA answer.'
      end
    else
      raise Synapsis::Error, JSON.parse(partially_linked_bank.body)['message']
    end
  end

  def self.view_linked_banks(params)
    self.new(params).view_linked_banks
  end

  def self.remove(bank_id, oauth_consumer_key)
    response =  Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url "#{API_V2_PATH}bank/delete/"
      req.body = JSON.generate(
        bank_id: bank_id,
        oauth_consumer_key: oauth_consumer_key
      )
    end

    return_response(response)
  end

  def view_linked_banks
    Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url "#{API_V2_PATH}bank/show/"
      req.body = build_json_from_variable_hash
    end
  end
end
