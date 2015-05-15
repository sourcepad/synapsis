require 'spec_helper'

RSpec.describe Synapsis::Card do
  describe '.add' do
    context 'happy path' do
      let!(:users_consumer_key) { 'dcd234d9d9fb55ad9711c4c41e254868ef3768d4' }
      it 'returns the created Card object' do
        card_params = {
          legal_name: 'Test Person',
          account_number: '1111111112',
          routing_number: '121000358',
          amount: 1,
          trans_type: 0,
          account_class: 1,
          account_type: 1,
          oauth_consumer_key: users_consumer_key
        }

        added_card_response = Synapsis::Card.add(card_params)

        expect(added_card_response).to respond_to(:card)
        expect(added_card_response.card).to respond_to(:id)
        expect(added_card_response).to respond_to(:success)
      end
    end
  end
end
