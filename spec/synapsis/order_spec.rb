require 'spec_helper'

RSpec.describe Synapsis::Order do
  context '#add' do
    let!(:delta) { 0.001 }
    let!(:buyer_consumer_key) { '3bdb5790692d06983d8cb0feb40365886631e52d' }
    let!(:seller_consumer_key) { '325ea5c0c3a7927280c54ed3ad310c02b45129d8' }
    let!(:order_params) {{
      amount: 1,
      oauth_consumer_key: buyer_consumer_key,
      seller_id: 3437
    }}

    context 'happy path' do
      it 'constructs the correct Order object' do
        order = Synapsis::Order.add(order_params)

        ORDER_PARAMS = ['account_type', 'amount', 'date', 'date_settled', 'discount', 'facilitator_fee', 'fee', 'id', 'is_buyer', 'note', 'resource_uri', 'seller', 'status', 'status_uri', 'ticket_number', 'tip', 'total']

        (ORDER_PARAMS - ['status_uri']).each do |x|
          expect(order.order.send(x)).not_to be_nil
        end
      end

      it 'subtracts the money from the consumer\'s account and adds to the seller\'s account' do
        buyer_account_balance = Synapsis::User.view(buyer_consumer_key).user.balance
        seller_account_balance = Synapsis::User.view(seller_consumer_key).user.balance

        order = Synapsis::Order.add(order_params)

        new_buyer_account_balance = Synapsis::User.view(buyer_consumer_key).user.balance
        new_seller_account_balance = Synapsis::User.view(seller_consumer_key).user.balance

        expect(new_buyer_account_balance).to be_within(delta).of(buyer_account_balance - order_params[:amount])
        expect(new_seller_account_balance).to be_within(seller_account_balance + order_params[:amount] - Synapsis::Order.synapse_fee(order_params[:amount]))
      end

      it 'subtracts the money from the consumer\'s account and adds to the seller\'s account, with a charge of ' do
        buyer_account_balance = Synapsis::User.view(buyer_consumer_key).user.balance
        seller_account_balance = Synapsis::User.view(seller_consumer_key).user.balance

        order = Synapsis::Order.add(order_params.merge(amount: 10.1))

        new_buyer_account_balance = Synapsis::User.view(buyer_consumer_key).user.balance
        new_seller_account_balance = Synapsis::User.view(seller_consumer_key).user.balance

        expect(new_buyer_account_balance).to be_within(delta).of(buyer_account_balance - 10.1)
        expect(new_seller_account_balance).to be_within(delta).of(seller_account_balance + 10.1- 0.25)
      end
    end

    context 'no amount specified' do
      it 'raises a Synapsis::Error' do
        expect{ Synapsis::Order.add(order_params.merge(oauth_consumer_key: 'WRONG!')) }.to raise_error(Synapsis::Error).with_message('Error in OAuth Authentication.')
        expect{ Synapsis::Order.add(order_params.merge(amount: 0)) }.to raise_error(Synapsis::Error).with_message('Missing amount')
        expect{ Synapsis::Order.add(order_params.merge(seller_id: 0)) }.to raise_error(Synapsis::Error).with_message('Missing seller_id')
      end
    end
  end
end
