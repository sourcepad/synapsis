require 'json'

module Synapsis::Utilities
  def build_json_from_params
    JSON.generate(to_hash.merge(client_credentials))
  end

  def to_hash
    instance_variables.map do |ivar|
      [ivar[1..-1], instance_variable_get(ivar)]
    end.to_h
  end

  def build_params_from_string
    to_hash.merge(client_credentials).map { |k, v| "#{k}=#{v}" }.join("&")
  end

  private

  def client_credentials
    {
      client_id: Synapsis.client_id,
      client_secret: Synapsis.client_secret
    }
  end
end
