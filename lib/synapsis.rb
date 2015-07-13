# External dependencies
require "faraday"

# Namespacing

module Synapsis
  module APIOperations; end
end

# Internal dependencies
require "synapsis/version"
require "synapsis/api_resource"
require "synapsis/api_operations/create"
require "synapsis/api_operations/edit"
require "synapsis/api_operations/view"
require "synapsis/user"
require "synapsis/bank"
require "synapsis/withdrawal"
require "synapsis/deposit"
require "synapsis/order"
require "synapsis/card"
require "synapsis/mass_pay"
require "synapsis/bank_status"
require "synapsis/error"

API_V2_PATH = 'api/v2/'

module Synapsis
  class << self
    attr_accessor :client_id, :client_secret, :environment

    def connection
      @connection ||= Faraday.new(url: synapse_url) do |faraday|
        faraday.request  :multipart             # form-encode POST params
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

  class Response < OpenStruct; end
end
