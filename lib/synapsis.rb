# External dependencies
require "faraday"

# Internal dependencies
require "synapsis/version"
require "synapsis/utilities"
require "synapsis/api_resource"
require "synapsis/authentication"
require "synapsis/user"
require "synapsis/bank"
require "synapsis/order"
require "synapsis/error"

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
        'https://synapsepay.com/'
      else
        'https://sandbox.synapsepay.com/'
      end
    end

    def configure(&params)
      yield(self)
    end
  end
end
