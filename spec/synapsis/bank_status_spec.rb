require 'spec_helper'

RSpec.describe Synapsis::BankStatus do
  describe '.show' do
    before(:each) do
      Synapsis.environment = 'production'
    end

    after(:each) do
      Synapsis.environment = 'development'
    end

    it 'shows' do
      bank_status_response = Synapsis::BankStatus.show

      expect(bank_status_response).to respond_to(:banks)
    end
  end
end
