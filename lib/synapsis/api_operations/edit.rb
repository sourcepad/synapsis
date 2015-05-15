module Synapsis::APIOperations::Edit
  def edit_request(params)
    request(:post, edit_url, params)
  end

  def edit_url
    "#{API_V2_PATH}#{class_name}/edit/"
  end
end

