class Synapsis::Order < Synapsis::APIResource
  include Synapsis::Utilities

  attr_accessor :balance_verified, :success, :account_type, :amount, :date, :date_settled, :discount, :facilitator_fee, :fee, :id, :is_buyer, :note, :resource_uri, :seller, :status, :status_uri, :ticket_number, :tip, :total

  ORDER_PARAMS = ['account_type', 'amount', 'date', 'date_settled', 'discount', 'facilitator_fee', 'fee', 'id', 'is_buyer', 'note', 'resource_uri', 'seller', 'status', 'status_uri', 'ticket_number', 'tip', 'total']

  SYNAPSE_FEE = 0.10

  def self.add(params)
    response = create_request(params)

    parsed_response = JSON.parse(response.body)

    if parsed_response['success']
      return new(parsed_response)
    else
      raise Synapsis::Error, parsed_response['reason']
    end
  end

  def self.synapse_fee
    SYNAPSE_FEE
  end

  def initialize(params)
    ['success', 'balance_verified'].each do |k|
      send("#{k}=", params[k])
    end

    ORDER_PARAMS.each do |k|
      send("#{k}=", params['order'][k])
    end
  end
end

