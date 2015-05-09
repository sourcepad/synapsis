class Synapsis::Order
  include Synapsis::Utilities

  attr_accessor :balance, :balance_verified, :success, :account_type, :amount, :date, :date_settled, :discount, :facilitator_fee, :fee, :id, :is_buyer, :note, :resource_uri, :seller, :status, :status_uri, :ticket_number, :tip, :total

  ORDER_PARAMS = ['account_type', 'amount', 'date', 'date_settled', 'discount', 'facilitator_fee', 'fee', 'id', 'is_buyer', 'note', 'resource_uri', 'seller', 'status', 'status_uri', 'ticket_number', 'tip', 'total']

  SYNAPSE_FEE = 0.10

  def self.create(params)
    response = Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url "#{API_V2_PATH}order/add/"
      req.body = JSON.generate(params)
    end

    if JSON.parse(response.body)['success']
      new(JSON.parse(response.body))
    else
      return Synapsis::Error.new(JSON.parse(response.body))
    end

    return self
  end

  def self.synapse_fee
    SYNAPSE_FEE
  end

  def initialize(params)
    ['success', 'balance', 'balance_verified'].each do |k|
      send("#{k}=", params[k])
    end

    ORDER_PARAMS.each do |k|
      send("#{k}=", params['order'][k])
    end
  end

end

