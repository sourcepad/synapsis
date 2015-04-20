require 'spec_helper'

RSpec.describe Synapsis do
  it 'can configure itself' do
    Synapsis.configure do |config|
      config.client_id = 'the_id'
      config.client_secret = 'the_secret'
    end

    expect(Synapsis.client_id).to eq 'the_id'
  end
end
