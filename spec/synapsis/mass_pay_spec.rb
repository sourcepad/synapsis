require 'spec_helper'

RSpec.describe Synapsis::MassPay do
  describe '.add' do
    # These tests might fail if the guy runs out of money
    context 'happy path' do
      let!(:delta) { 0.001 }
      let!(:users_consumer_key) { 'dcd234d9d9fb55ad9711c4c41e254868ef3768d4' }
      let!(:mass_pay_hash) {{
        legal_name: 'Test Person',
        account_number: '1111111112',
        routing_number: '121000358',
        amount: 1,
        trans_type: 0,
        account_class: 1,
        account_type: 1
      }}
      let!(:mass_pay_hash2) {{
        legal_name: 'Test Person2',
        account_number: '1111111112',
        routing_number: '121000359',
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
end


