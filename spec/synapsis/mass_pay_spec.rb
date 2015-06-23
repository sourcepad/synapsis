require 'spec_helper'

RSpec.describe Synapsis::MassPay do
  let!(:users_consumer_key) { 'dcd234d9d9fb55ad9711c4c41e254868ef3768d4' }
  describe '.add and .cancel' do
    # These tests might fail if the guy runs out of money
    context 'happy path' do
      let!(:delta) { 0.001 }
      let!(:mass_pay_hash) {{
        legal_name: 'Test Person',
        account_number: '1111111112',
        routing_number: get_random_routing_number,
        amount: 1,
        trans_type: 0,
        account_class: 1,
        account_type: 1
      }}
      let!(:mass_pay_hash2) {{
        legal_name: 'Test Person2',
        account_number: '1111111112',
        routing_number: get_random_routing_number,
        amount: 1,
        trans_type: 0,
        account_class: 1,
        account_type: 1
      }}

      it 'returns an array of MassPay objects' do
        mass_pay_response = Synapsis::MassPay.add(
          mass_pays: [mass_pay_hash, mass_pay_hash2],
          oauth_consumer_key: users_consumer_key)

        expect(mass_pay_response).to respond_to(:mass_pays)
        expect(mass_pay_response.mass_pays.count).to eq 2
        expect(mass_pay_response.mass_pays.first.status).to eq Synapsis::MassPay::Status::CREATED
        expect(mass_pay_response).to respond_to(:success)

        deleted_mass_pay_response = Synapsis::MassPay.cancel(
          id: mass_pay_response.mass_pays.first.id,
          oauth_consumer_key: users_consumer_key
        )

        expect(deleted_mass_pay_response.mass_pays.first.status).to eq Synapsis::MassPay::Status::CANCELLED
      end

      it 'deducts the user\'s account by the total amount plus 0.1 per mass pay' do
        users_balance = Synapsis::User.view(users_consumer_key).user.balance

        Synapsis::MassPay.add(
          mass_pays: [mass_pay_hash, mass_pay_hash2],
          oauth_consumer_key: users_consumer_key)

        users_balance_after = Synapsis::User.view(users_consumer_key).user.balance
        expect(users_balance_after).to be_within(delta).of(users_balance - mass_pay_hash[:amount] - mass_pay_hash2[:amount] - (2 * Synapsis::MassPay.cost_per_mass_pay))
      end
    end
  end

  describe '.add (via cards)' do
    # These tests might fail if the guy runs out of money
    context 'happy path' do
      let!(:delta) { 0.001 }
      let!(:mass_pay_hash) {{
        amount: 1,
        card_id: 359,
        trans_type: 0
      }}
      let!(:mass_pay_hash2) {{
        amount: 1,
        card_id: 360,
        trans_type: 0
      }}

      it 'returns an array of MassPay objects' do
        mass_pay_response = Synapsis::MassPay.add(
          mass_pays: [mass_pay_hash, mass_pay_hash2],
          oauth_consumer_key: users_consumer_key)

        expect(mass_pay_response).to respond_to(:mass_pays)
        expect(mass_pay_response.mass_pays.count).to eq 2
        expect(mass_pay_response).to respond_to(:success)
      end

      it 'deducts the user\'s account by the total amount plus 0.1 per mass pay' do
        users_balance = Synapsis::User.view(users_consumer_key).user.balance

        Synapsis::MassPay.add(
          mass_pays: [mass_pay_hash, mass_pay_hash2],
          oauth_consumer_key: users_consumer_key)

        users_balance_after = Synapsis::User.view(users_consumer_key).user.balance
        expect(users_balance_after).to be_within(delta).of(users_balance - mass_pay_hash[:amount] - mass_pay_hash2[:amount] - (2 * Synapsis::MassPay.cost_per_mass_pay))
      end
    end
  end

  describe '.show' do
    context 'with mass_pay_id argument' do
      context 'happy path' do
        it 'returns a MassPay object' do
          view_params = {
            mass_pay_id: 721,
            oauth_consumer_key: users_consumer_key
          }

          mass_pay_response = Synapsis::MassPay.show(view_params)

          [:success, :mass_pays, :obj_count]. each do |param|
            expect(mass_pay_response).to respond_to(param)
          end
          expect(mass_pay_response.obj_count).to eq 1
        end
      end

      context 'bad_parameters' do
        it 'raises an error' do
          # Authentication isn't owned by the user
          expect { Synapsis::MassPay.show(mass_pay_id: 721, oauth_consumer_key: 'WRONG KEY') }.to raise_error(Synapsis::Error).with_message('Error in OAuth Authentication.')

          # Bad ID
          expect { Synapsis::MassPay.show(mass_pay_id: 'a', oauth_consumer_key: users_consumer_key) }.to raise_error(Synapsis::Error).with_message('id not formatted correctly.')

          # No mass_pay_id argument: fails
          expect { Synapsis::MassPay.show(oauth_consumer_key: users_consumer_key) }.to raise_error(Synapsis::Error).with_message('id not formatted correctly.')

          # If mass_pay_id isn't owned by the user, Synapse's behavior is to return an array of empty mass_pays.
          mass_pay_with_bad_id_but_is_integer = Synapsis::MassPay.show(mass_pay_id: 99999, oauth_consumer_key: users_consumer_key)

          expect(mass_pay_with_bad_id_but_is_integer.mass_pays.count).to eq 0
        end
      end
    end
  end
end
