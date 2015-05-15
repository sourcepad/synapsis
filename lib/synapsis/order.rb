class Synapsis::Order < Synapsis::APIResource
  include Synapsis::Utilities
  extend Synapsis::APIOperations::Create

  def self.add(params)
    response = create_request(params)
    return_response(response)
  end

  def self.poll(order_id:)
    response = request(:post, poll_url, order_id: order_id)
    return_response(response)
  end

  def self.synapse_fee(transaction_amount)
    if transaction_amount > 10
      0.25
    else
      0.1
    end
  end

  private

  def self.poll_url
    "#{API_V2_PATH}order/poll"
  end
end

