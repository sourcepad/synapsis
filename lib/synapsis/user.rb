require 'json'

class Synapsis::User
  attr_accessor :email, :fullname, :ip_address, :phonenumber

  def self.build_json_from_params(kv_pairs)
    JSON.generate(kv_pairs.merge(
      client_id: Synapsis.client_id,
      client_secret: Synapsis.client_secret
    ))
  end

  def self.create(params)
    resp = Synapsis.connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.url 'user/create/'
      req.body = Synapsis::User.build_json_from_params(params)
    end

    return resp
  end
end
