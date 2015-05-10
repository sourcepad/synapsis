require 'spec_helper'

RSpec.describe Synapsis::Order do
  context '#add' do
    context 'happy path' do
      it 'constructs the correct Order object' do
        order_params = {
          amount: 1,
          oauth_consumer_key: '3bdb5790692d06983d8cb0feb40365886631e52d',
          seller_id: 3437
        }

        order = Synapsis::Order.add(order_params)

        # Ensure Order object responds to all the params in a Synapse response object
        (order.instance_variables - [:@status_uri]).each do |x|
          expect(order.send(x.to_s.gsub('@', ''))).not_to be_nil
        end
      end

      it 'subtracts the money from the consumer\'s account and adds to the seller\'s account' do
        buyer_account_balance = Synapsis::User.view('3bdb5790692d06983d8cb0feb40365886631e52d').balance
        seller_account_balance = Synapsis::User.view('325ea5c0c3a7927280c54ed3ad310c02b45129d8').balance

        order_params = {
          amount: 1,
          oauth_consumer_key: '3bdb5790692d06983d8cb0feb40365886631e52d',
          seller_id: 3437
        }

        order = Synapsis::Order.add(order_params)

        new_buyer_account_balance = Synapsis::User.view('3bdb5790692d06983d8cb0feb40365886631e52d').balance
        new_seller_account_balance = Synapsis::User.view('325ea5c0c3a7927280c54ed3ad310c02b45129d8').balance

        expect(new_buyer_account_balance).to eq buyer_account_balance - order_params[:amount]
        expect(new_seller_account_balance).to eq seller_account_balance + order_params[:amount] - Synapsis::Order.synapse_fee
      end
    end
  end
end
