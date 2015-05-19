module Synapsis::APIOperations::Edit
  def edit(params)
    response = edit_request(params)
    return_response(response)
  end

  def edit_request(params)
    request(:post, edit_url, params)
  end

  def edit_url
    "#{API_V2_PATH}#{class_name}/edit"
  end
end

