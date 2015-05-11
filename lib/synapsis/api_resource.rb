class Synapsis::APIResource
  def self.class_name
    name.partition('::').last.downcase
  end

  def self.create_request(params)
    Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url create_url
      req.body = JSON.generate(params)
    end
  end

  def self.create_url
    "#{API_V2_PATH}#{class_name}/add"
  end
end
