require 'spec_helper'

RSpec.describe Synapsis::Deposit do
  context '#add' do
    let!(:deposit_params) {{
      amount: 100,
      oauth_consumer_key: '3bdb5790692d06983d8cb0feb40365886631e52d',
      bank_id: 2182
    }}

    context 'happy path' do
      it 'constructs the correct deposit object' do
        deposit_response = Synapsis::Deposit.create(deposit_params)

        DEPOSIT_SPECIFIC_PARAMS = ['amount', 'bank', 'date_created', 'id', 'resource_uri', 'status', 'status_url', 'user_id']

        (DEPOSIT_SPECIFIC_PARAMS - ['status_url']).each do |x|
          expect(deposit_response.deposit.send(x.to_s.gsub('@', ''))).not_to be_nil
        end
      end
    end

    context 'errors' do
      it 'create a Synapsis::Error object' do
        # Missing amount
        expect { Synapsis::Deposit.create(deposit_params.merge(amount: 0)) }.to raise_error(Synapsis::Error).with_message('Missing amount')

        # OAuth error
        expect { Synapsis::Deposit.create(deposit_params.merge(oauth_consumer_key: 'WRONG!!!')) }.to raise_error(Synapsis::Error).with_message('Error in OAuth Authentication.')

        # Wrong bank ID (user does not own bank_id 1)
        expect{ Synapsis::Deposit.create(deposit_params.merge(bank_id: 1))}.to raise_error(Synapsis::Error).with_message('Bank account not associated with the user')
      end
    end
  end
end
