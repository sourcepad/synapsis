class Synapsis::Deposit < Synapsis::APIResource
  extend Synapsis::APIOperations::Create

  # amount, bank_id, oauth_consumer_key
  # amount must be supplied using a string
  def self.create(params)
    response = create_request(params)
    return_response(response)
  end
end
