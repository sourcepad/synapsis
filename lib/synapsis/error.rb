class Synapsis::Error
  attr_accessor :reason

  def initialize(error_params)
    @reason = error_params['reason']
  end
end
