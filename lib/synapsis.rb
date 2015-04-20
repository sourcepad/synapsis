# External dependencies
require "faraday"

# Internal dependencies

require "./lib/synapsis/version"
require "./lib/synapsis/user"

module Synapsis
  class << self
    attr_accessor :client_id, :client_secret, :environment

    def connection
      @connection ||= Faraday.new(url: synapse_url) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def synapse_url
      if environment == 'production'
        'https://synapsepay.com/api/v2'
      else
        'https://sandbox.synapsepay.com/api/v2'
      end
    end

    def configure(&params)
      yield(self)
    end
  end
end
