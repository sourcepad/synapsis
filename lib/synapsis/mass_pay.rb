class Synapsis::MassPay < Synapsis::APIResource
  extend Synapsis::APIOperations::Create

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
end

