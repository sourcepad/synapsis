require 'json'

module Synapsis::Utilities
  def build_json_from_params(kv_pairs)
    JSON.generate(kv_pairs.merge(
      client_id: Synapsis.client_id,
      client_secret: Synapsis.client_secret
    ))
  end

  def to_hash
    instance_variables.map do |ivar|
      [ivar[1..-1], instance_variable_get(ivar)]
    end.to_h
  end
end
