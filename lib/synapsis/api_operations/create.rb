module Synapsis::APIOperations::Create
  def create_request(params)
    request(:post, create_url, params)
  end

  def create_url
    "#{API_V2_PATH}#{class_name}/add"
  end
end

