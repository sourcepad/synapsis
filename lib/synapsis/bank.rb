class Synapsis::Bank < Synapsis::APIResource
  include Synapsis::Utilities
  extend Synapsis::APIOperations::Create
  extend Synapsis::APIOperations::View

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
    partially_linked_bank = request(:post, bank_link_url, params)
    parsed_partially_linked_bank = parse_as_synapse_resource(partially_linked_bank)

    if parsed_partially_linked_bank.success
      if parsed_partially_linked_bank.banks # This happens if the added bank has no MFA
        return parsed_partially_linked_bank
      end

      @access_token = parsed_partially_linked_bank.response.access_token

      new_bank = request(:post, bank_mfa_url, params.merge(access_token: @access_token))
      parsed_new_bank = parse_as_synapse_resource(new_bank)

      if parsed_new_bank.banks # SynapseAPI will return an array of the banks if the MFA process was successful
        return parsed_new_bank
      else
        raise Synapsis::Error, 'Wrong MFA answer.'
      end
    else
      raise Synapsis::Error, JSON.parse(partially_linked_bank.body)['message']
    end
  end

  def self.view_linked_banks(oauth_token)
    response = view_request(oauth_consumer_key: oauth_token)
    return_response(response)
  end

  def self.remove(bank_id, oauth_consumer_key)
    params = {
      bank_id: bank_id,
      oauth_consumer_key: oauth_consumer_key
    }

    response = request(:post, bank_delete_url, params)
    return_response(response)
  end

  private

  def self.bank_link_url
    "#{API_V2_PATH}bank/login/?is_dev=yes"
  end

  def self.bank_mfa_url
    "#{API_V2_PATH}bank/mfa/?is_dev=yes"
  end

  def self.bank_delete_url
    "#{API_V2_PATH}bank/delete/"
  end
end
