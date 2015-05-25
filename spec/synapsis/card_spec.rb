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

  describe '.show' do
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

  describe '.edit' do
    let!(:edit_card_params) {{
      oauth_consumer_key: users_consumer_key,
      id: 483,
      legal_name: Faker::Name.name,
      account_number: "11111111#{rand(1..9)}#{rand(1..9)}",
      routing_number: get_random_routing_number,
      account_class: rand(1..2),
      account_type: rand(1..2)
    }}

    context 'happy path' do
      it 'edits the card' do
        edited_card_response = Synapsis::Card.edit(edit_card_params)

        [:account_class, :account_type].each do |param|
          expect(edited_card_response.card.send(param)).to eq edit_card_params[param]
        end

        expect(edited_card_response.card.account_number_string).to include edit_card_params[:account_number][-1, 2] # Since only last 2 digits are saved we ensure that the account numbers and routing numbers are actually changed
        expect(edited_card_response.card.routing_number_string).to include edit_card_params[:routing_number][-1, 2] # Since only last 2 digits are saved we ensure that the account numbers and routing numbers are actually changed
        expect(edited_card_response.card.name_on_account).to eq edit_card_params[:legal_name]
      end
    end

    context 'wrong parameters' do
      it 'raises errors' do
        # Wrong OAuth consumer key
        expect { Synapsis::Card.edit(edit_card_params.merge(oauth_consumer_key: 'WRONG')) }.to raise_error(Synapsis::Error).with_message('Error in OAuth Authentication.')

        # User does not own the card
        expect { Synapsis::Card.edit(edit_card_params.merge(id: 5)) }.to raise_error(Synapsis::Error).with_message('Card not found')

        # Wrong account class
        expect { Synapsis::Card.edit(edit_card_params.merge(account_class: 'WRONG')) }.to raise_error(Synapsis::Error).with_message('account_class not supplied or incorrectly formatted')

        # Wrong account type
        expect { Synapsis::Card.edit(edit_card_params.merge(account_type: 'WRONG')) }.to raise_error(Synapsis::Error).with_message('account_type not supplied or incorrectly formatted')
      end

      xit 'doesn\'t raise errors on invalid account numbers and routing numbers' do
        # Invalid account number DOES NOT RAISE AN ERROR
        expect { Synapsis::Card.edit(edit_card_params.merge(account_number: 'THIS IS NOT REAL')) }.to raise_error(Synapsis::Error).with_message('Error in OAuth Authentication.')

        # Invalid account number DOES NOT RAISE AN ERROR
        expect { Synapsis::Card.edit(edit_card_params.merge(routing_number: 'THIS IS NOT REAL')) }.to raise_error(Synapsis::Error).with_message('Error in OAuth Authentication.')
      end
    end
  end
end
