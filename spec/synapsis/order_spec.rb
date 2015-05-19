require 'spec_helper'

RSpec.describe Synapsis::Order do
  let!(:buyer_consumer_key) { '3bdb5790692d06983d8cb0feb40365886631e52d' }
  let!(:seller_consumer_key) { '325ea5c0c3a7927280c54ed3ad310c02b45129d8' }
  let!(:order_params) {{
    amount: 1,
    oauth_consumer_key: buyer_consumer_key,
    seller_id: 3437
  }}

  context '.add' do
    let!(:delta) { 0.001 }

    context 'happy path' do
      it 'constructs the correct Order object' do
        order_response = Synapsis::Order.add(order_params)

        FIRST_LEVEL_PARAMS = ['balance_verified', 'order', 'success']

        ORDER_PARAMS = ['account_type', 'amount', 'date', 'date_settled', 'discount', 'facilitator_fee', 'fee', 'id', 'is_buyer', 'note', 'resource_uri', 'seller', 'status', 'status_url', 'ticket_number', 'tip', 'total']

        FIRST_LEVEL_PARAMS.each do |param|
          expect(order_response).to respond_to(param)
        end

        ORDER_PARAMS.each do |x|
          expect(order_response.order).to respond_to(x)
        end
      end

      xit 'pending due to a bug wherein the buyer\'s balance does not get decremented--subtracts the money from the consumer\'s account and adds to the seller\'s account' do
        buyer_account_balance = Synapsis::User.view(buyer_consumer_key).user.balance
        seller_account_balance = Synapsis::User.view(seller_consumer_key).user.balance

        order_response = Synapsis::Order.add(order_params)

        new_buyer_account_balance = Synapsis::User.view(buyer_consumer_key).user.balance
        new_seller_account_balance = Synapsis::User.view(seller_consumer_key).user.balance

        expect(new_buyer_account_balance).to be_within(delta).of(buyer_account_balance - order_params[:amount])
        expect(new_seller_account_balance).to be_within(delta).of(seller_account_balance + order_params[:amount] - Synapsis::Order.synapse_fee(order_params[:amount]))
      end

      xit 'pending due to a bug wherein the buyer\'s balance does not get decremented--subtracts the money from the consumer\'s account and adds to the seller\'s account, with a charge of 0.25 if amount is greater than $10' do
        buyer_account_balance = Synapsis::User.view(buyer_consumer_key).user.balance
        seller_account_balance = Synapsis::User.view(seller_consumer_key).user.balance

        order_response = Synapsis::Order.add(order_params.merge(amount: 10.1))

        new_buyer_account_balance = Synapsis::User.view(buyer_consumer_key).user.balance
        new_seller_account_balance = Synapsis::User.view(seller_consumer_key).user.balance

        expect(new_buyer_account_balance).to be_within(delta).of(buyer_account_balance - 10.1)
        expect(new_seller_account_balance).to be_within(delta).of(seller_account_balance + 10.1- 0.25)
      end
    end

    context 'errors' do
      it 'raises a Synapsis::Error' do
        expect{ Synapsis::Order.add(order_params.merge(oauth_consumer_key: 'WRONG!')) }.to raise_error(Synapsis::Error).with_message('Error in OAuth Authentication.')
        expect{ Synapsis::Order.add(order_params.merge(amount: 0)) }.to raise_error(Synapsis::Error).with_message('Missing amount')
        expect{ Synapsis::Order.add(order_params.merge(seller_id: 0)) }.to raise_error(Synapsis::Error).with_message('Missing seller_id')
      end
    end
  end

  context '.poll' do
    context 'happy path' do
      it 'retrieves the order' do
        order_id = 1398
        polled_order_response = Synapsis::Order.poll(order_id: 1398)

        FIRST_LEVEL_PARAMS = ['order', 'success']

        FIRST_LEVEL_PARAMS.each do |param|
          expect(polled_order_response).to respond_to(param)
        end

        expect(polled_order_response.order.status).not_to be_nil
      end
    end
  end

  context '.void' do
    context 'happy path' do
      it 'voids an order' do
        existing_order_id = Synapsis::Order.add(order_params).order.id

        voided_order_response = Synapsis::Order.void(
          order_id: existing_order_id,
          oauth_consumer_key: seller_consumer_key
        )

        expect(voided_order_response.order.status).to eq Synapsis::Order::Status::CANCELLED
      end
    end

    context 'errors' do
      it 'raises an error' do
        existing_order_id = Synapsis::Order.add(order_params).order.id

        expect{ Synapsis::Order.void(
          order_id: existing_order_id,
          oauth_consumer_key: buyer_consumer_key
        ) }.to raise_error(Synapsis::Error).with_message('cannot void this order')
      end
    end
  end
end
