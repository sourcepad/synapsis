module Synapsis::APIOperations::View
  def view_request(params)
    request(:post, view_url, params)
  end

  def view_url
    "#{API_V2_PATH}#{class_name}/show"
  end
end
