class Synapsis::Deposit < Synapsis::APIResource
  include Synapsis::Utilities
  extend Synapsis::APIOperations::Create

  def self.create(params)
    response = create_request(params)

    return_response(response)
  end
end
