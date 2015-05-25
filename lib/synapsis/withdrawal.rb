class Synapsis::Withdrawal < Synapsis::APIResource
  extend Synapsis::APIOperations::Create
  extend Synapsis::APIOperations::View

  # Note: If you do not supply the bank_id, Synapse will attempt to withdraw from the primary bank.
  def self.create(params)
    response = create_request(params)
    return_response(response)
  end

  def self.view(params)
    response = view_request(params)
    return_response(response)
  end

  private

  # SynapseAPI's URI for withdrawals is /withdraw, not /withdrawal
  def self.class_name
    'withdraw'
  end
end
