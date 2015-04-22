class Synapsis::Bank
  include Synapsis::Utilities

  ADD_BANK_URL = "#{API_V2_PATH}bank/add/"

  attr_accessor :fullname,
    :account_num,
    :routing_num,
    :nickname,
    :account_class,
    :account_type,
    :oauth_consumer_key

  def self.add(params)
    self.new(params).add
  end

  def initialize(params)
    params.each do |k, v|
      send("#{k}=", v)
    end
  end

  def add
    Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url ADD_BANK_URL
      req.body = build_json_from_variable_hash
    end
  end
end
