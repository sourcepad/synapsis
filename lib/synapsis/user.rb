class Synapsis::User
  include Synapsis::Utilities

  attr_accessor :email, :fullname, :ip_address, :phonenumber

  def self.create(params)
    self.new(params).create
  end

  def initialize(params)
    params.each do |k, v|
      send("#{k}=", v)
    end
  end

  def create
    Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url 'user/create/'
      req.body = build_json_from_params(to_hash)
    end
  end
end
