module Synapsis::APIOperations::View
  def view_request(params)
    Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url view_url
      req.body = JSON.generate(params)
    end
  end

  def view_url
    "#{API_V2_PATH}#{class_name}/show"
  end
end
