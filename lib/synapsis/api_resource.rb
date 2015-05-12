class Synapsis::APIResource
  def self.class_name
    name.partition('::').last.downcase
  end

  def class_name
    self.class.name.partition('::').last.downcase
  end

  def self.return_response(response)
    parsed_response = JSON.parse(response.body, object_class: Synapsis::Response)

    if response.success?
      return parsed_response
    else
      raise Synapsis::Error, parsed_response['reason']
    end
  end

  def self.parse_as_synapse_resource(response)
    return JSON.parse(response.body, object_class: Synapsis::Response)
  end
end
