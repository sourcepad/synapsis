class Synapsis::Order < Synapsis::APIResource
  include Synapsis::Utilities
  extend Synapsis::APIOperations::Create

  def self.add(params)
    response = create_request(params)
    return_response(response)
  end

  def self.synapse_fee(transaction_amount)
    if transaction_amount > 10
      0.25
    else
      0.1
    end
  end
end

