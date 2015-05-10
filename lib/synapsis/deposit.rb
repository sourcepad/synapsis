class Synapsis::Deposit < Synapsis::APIResource
  include Synapsis::Utilities

  attr_accessor :reason,
    :success,
    :amount,
    :bank,
    :date_created,
    :id,
    :resource_uri,
    :status,
    :status_url,
    :user_id

  DEPOSIT_SPECIFIC_PARAMS = ['amount', 'bank', 'date_created', 'id', 'resource_uri', 'status', 'status_url', 'user_id']

  def self.create(params)
    response = create_request(params)

    if response.success?
      new(JSON.parse(response.body))
    else
      Synapsis::Error.new(JSON.parse(response.body))
    end
  end

  def initialize(params)
    ['reason', 'success'].each do |k|
      send("#{k}=", params[k])
    end

    DEPOSIT_SPECIFIC_PARAMS.each do |k|
      send("#{k}=", params['deposit'][k])
    end
  end
end
