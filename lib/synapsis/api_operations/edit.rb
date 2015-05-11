module Synapsis::APIOperations::Edit
  def edit_request(params)
    Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url edit_url
      req.body = JSON.generate(params)
    end
  end

  def edit_url
    "#{API_V2_PATH}#{class_name}/edit/"
  end
end

