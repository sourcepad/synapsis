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
        withdrawal = Synapsis::Withdrawal.create(withdrawal_params)

        (withdrawal.instance_variables - [:@status_url]).each do |x|
          expect(withdrawal.send(x.to_s.gsub('@', ''))).not_to be_nil
        end
      end
    end

    context 'Error: No amount' do
      it 'creates a Synapsis::Error object' do
        withdrawal = Synapsis::Withdrawal.create(withdrawal_params.merge(amount: 0))

        expect(withdrawal).to be_a_kind_of(Synapsis::Error)
        expect(withdrawal.reason).to eq 'Missing amount'
      end
    end

    context 'Error: OAuth' do
      it 'creates a Synapsis::Error object' do
        withdrawal = Synapsis::Withdrawal.create(withdrawal_params.merge(oauth_consumer_key: 'WRONG!!!'))

        expect(withdrawal).to be_a_kind_of(Synapsis::Error)
        expect(withdrawal.reason).to eq 'Error in OAuth Authentication.'
      end
    end

    context 'Error: Wrong bank ID' do
      it 'creates a Synapsis::Error object' do
        withdrawal = Synapsis::Withdrawal.create(withdrawal_params.merge(bank_id: 1)) # User does not own bank_id 1

        expect(withdrawal).to be_a_kind_of(Synapsis::Error)
        expect(withdrawal.reason).to eq 'Bank account not associated with the user'
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

