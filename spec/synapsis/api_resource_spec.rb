require 'spec_helper'

RSpec.describe Synapsis::APIResource do
  context '.class_name' do
    it 'gets the class name, without the Synapsis namespace' do
      class Synapsis::Thingie < Synapsis::APIResource; end

      expect(Synapsis::Thingie.class_name).to eq 'thingie'
      expect(Synapsis::Thingie.create_url).to eq 'api/v2/thingie/add'
    end
  end
end
