class Synapsis::Card < Synapsis::APIResource
  extend Synapsis::APIOperations::Create
  extend Synapsis::APIOperations::Edit
  extend Synapsis::APIOperations::View

  def self.add(params)
    response = create_request(params)
    return_response(response)
  end

  def self.show(params)
    view(params)
  end

  # self.edit parameters: oauth_consumer_key, id, legal_name, account_number, routing_number, account_class, account_type
end

