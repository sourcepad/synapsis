require 'spec_helper'

RSpec.describe Synapsis::Withdrawal do
  context '#add' do
    let!(:withdrawal_params) {{
      amount: 100,
      oauth_consumer_key: '3bdb5790692d06983d8cb0feb40365886631e52d',
      bank_id: 2182
    }}

    context 'happy path' do
      it 'constructs the correct Withdrawal object' do
        withdrawal_response = Synapsis::Withdrawal.create(withdrawal_params)

        WITHDRAWAL_SPECIFIC_PARAMS = ['amount', 'bank', 'date_created', 'fee', 'id', 'instant_credit', 'resource_uri', 'status', 'status_url', 'user_id']

        (WITHDRAWAL_SPECIFIC_PARAMS - ['status_url']).each do |x|
          expect(withdrawal_response.withdrawal.send(x.to_s.gsub('@', ''))).not_to be_nil
        end
      end
    end

    context 'errors' do
      it 'create a Synapsis::Error object' do
        # Missing amount
        expect { Synapsis::Withdrawal.create(withdrawal_params.merge(amount: 0)) }.to raise_error(Synapsis::Error).with_message('Missing amount')

        # OAuth error
        expect { Synapsis::Withdrawal.create(withdrawal_params.merge(oauth_consumer_key: 'WRONG!!!')) }.to raise_error(Synapsis::Error).with_message('Error in OAuth Authentication.')

        # Wrong bank ID (user does not own bank_id 1)
        expect{ Synapsis::Withdrawal.create(withdrawal_params.merge(bank_id: 1))}.to raise_error(Synapsis::Error).with_message('Bank account not associated with the user')
      end
    end
  end

  context '#view' do
    context 'no ID' do
      let!(:withdrawal_params) {{
        oauth_consumer_key: '3bdb5790692d06983d8cb0feb40365886631e52d'
      }}

      context 'happy path' do
        xit 'returns an array of the user\'s withdrawals' do
          all_withdrawals = Synapsis::Withdrawal.view(withdrawal_params)
        end
      end
    end

    context 'with ID' do
      let!(:withdrawal_params) {{
        id: 354,
        oauth_consumer_key: '3bdb5790692d06983d8cb0feb40365886631e52d'
      }}

      context 'happy path' do
        xit 'returns an array of the user\'s withdrawals' do
          pending
        end
      end
    end
  end
end

