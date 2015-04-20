class Synapsis::Authentication
  include Synapsis::Utilities

  attr_accessor :username, :password, :grant_type, :scope

  def self.login(params)
    self.new(params).login
  end

  def initialize(params)
    params.each do |k, v|
      send("#{k}=", v)
    end

    @grant_type = 'password'
    @scope = 'write'
  end

  def login
    Synapsis.connection.post do |req|
      req.url 'oauth2/access_token'
      req.body = build_params_from_string
    end
  end
end
