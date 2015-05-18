class Synapsis::MassPay < Synapsis::APIResource
  extend Synapsis::APIOperations::Create
  extend Synapsis::APIOperations::View

  module Status
    WITHDRAWAL_HAPPENING = 0
    CREATED = 1
    IN_PROGRESS = 2
    SETTLED = 3
    CANCELLED = 4
    RETURNED = 5
  end

  COST_PER_MASS_PAY = 0.1

  def self.cost_per_mass_pay
    COST_PER_MASS_PAY
  end

  def self.add(mass_pays:, oauth_consumer_key:)
    params = {
      mass_pays: mass_pays,
      oauth_consumer_key: oauth_consumer_key
    }

    response = create_request(params)
    return_response(response)
  end

  def self.show(mass_pay_id: {}, oauth_consumer_key:)
    params = {
      id: mass_pay_id,
      oauth_consumer_key: oauth_consumer_key
    }

    response = view_request(params)
    return_response(response)
  end

  def self.cancel(params)
    response = request(:post, cancel_url, params)
    return_response(response)
  end

  private

  def self.cancel_url
    "#{API_V2_PATH}masspay/cancel"
  end
end

