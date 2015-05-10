class Synapsis::Withdrawal < Synapsis::APIResource
  include Synapsis::Utilities

  attr_accessor :balance,
    :is_mfa,
    :reason,
    :success,
    :amount,
    :bank,
    :date_created,
    :fee,
    :id,
    :instant_credit,
    :resource_uri,
    :status,
    :status_url,
    :user_id

  WITHDRAWAL_SPECIFIC_PARAMS = ['amount', 'bank', 'date_created', 'fee', 'id', 'instant_credit', 'resource_uri', 'status', 'status_url', 'user_id']

  # Note: If you do not supply the bank_id, Synapse will attempt to withdraw from the primary bank.
  def self.create(params)
    response = create_request(params)

    if response.success?
      new(JSON.parse(response.body))
    else
      Synapsis::Error.new(JSON.parse(response.body))
    end
  end


  def initialize(params)
    ['balance', 'is_mfa', 'reason', 'success'].each do |k|
      send("#{k}=", params[k])
    end

    WITHDRAWAL_SPECIFIC_PARAMS.each do |k|
      send("#{k}=", params['withdrawal'][k])
    end
  end

  private

  # SynapseAPI's URI for withdrawals is /withdraw, not /withdrawal
  def self.class_name
    'withdraw'
  end
end
