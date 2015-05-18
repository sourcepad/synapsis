require 'spec_helper'

RSpec.describe Synapsis::Card do
  let!(:users_consumer_key) { 'dcd234d9d9fb55ad9711c4c41e254868ef3768d4' }
  describe '.add' do
    context 'happy path' do
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

  context '.show' do
    context 'without id parameter' do
      context 'happy path' do
        it 'shows all of the user\'s cards' do
          card_params = {
            oauth_consumer_key: users_consumer_key
          }

          shown_card_response = Synapsis::Card.show(card_params)

          expect(shown_card_response).to respond_to(:cards)
          expect(shown_card_response.obj_count).to be > 1
        end
      end
    end
  end
end
