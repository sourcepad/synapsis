class Synapsis::Card < Synapsis::APIResource
  extend Synapsis::APIOperations::Create

  def self.add(params)
    response = create_request(params)
    return_response(response)
  end
end

