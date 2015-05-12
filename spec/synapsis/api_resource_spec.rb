require 'spec_helper'

RSpec.describe Synapsis::APIResource do
  context '.class_name' do
    it 'gets the class name, without the Synapsis namespace' do
      class Synapsis::Thingie < Synapsis::APIResource; end

      expect(Synapsis::Thingie.class_name).to eq 'thingie'
    end
  end
end
