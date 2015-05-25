class Synapsis::Order < Synapsis::APIResource
  extend Synapsis::APIOperations::Create

  module Status
    QUEUED_INVESTIGATING = -1
    QUEUED = 0
    CREATED = 1
    IN_PROGRESS = 2
    SETTLED = 3
    CANCELLED = 4
    RETURNED = 5
  end

  def self.add(params)
    response = create_request(params)
    return_response(response)
  end

  def self.poll(order_id:)
    response = request(:post, poll_url, order_id: order_id)
    return_response(response)
  end

  # Consumer key of the seller
  def self.void(order_id:, oauth_consumer_key:)
    params = {
      order_id: order_id,
      oauth_consumer_key: oauth_consumer_key
    }

    response = request(:post, void_url, params)
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

  def self.void_url
    "#{API_V2_PATH}order/void"
  end
end

