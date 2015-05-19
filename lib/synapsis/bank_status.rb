class Synapsis::BankStatus < Synapsis::APIResource
  extend Synapsis::APIOperations::View

  # Must be on a production environment (Synapsis.environment = 'production')
  def self.show
    view({})
  end
end

