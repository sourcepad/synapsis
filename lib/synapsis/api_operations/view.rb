module Synapsis::APIOperations::View
  def view(params)
    response = view_request(params)
    return_response(response)
  end

  def view_request(params)
    request(:post, view_url, params)
  end

  def view_url
    "#{API_V2_PATH}#{class_name}/show"
  end
end
