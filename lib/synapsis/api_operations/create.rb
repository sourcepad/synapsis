module Synapsis::APIOperations::Create
  def create_request(params)
    Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url create_url
      req.body = JSON.generate(params)
    end
  end

  def create_url
    "#{API_V2_PATH}#{class_name}/add"
  end
end

