require 'spec_helper'

RSpec.describe Synapsis::Bank do
  context '#link' do
    let(:user_params) { {
      email: Faker::Internet.email,
      fullname: Faker::Name.name,
      phonenumber: Faker::PhoneNumber.phone_number,
      password: '5ourcep4d',
      ip_address: '8.8.8.8'
    }}

    context 'question-based MFA' do
      it 'adds a bank account' do
        new_user = Synapsis::User.create(user_params)

        bank_params = {
          username: 'synapse_good',
          password: 'test1234',
          oauth_consumer_key: new_user.access_token,
          bank: 'PNC',
          mfa: 'test_answer'
        }

        new_bank = Synapsis::Bank.link(bank_params)

        expect(new_bank.name_on_account).to eq user_params[:fullname]
        expect(new_bank.bank_name).to eq bank_params[:bank]
      end

      context 'errors' do
        it 'bad username returns a SynapsisError' do
          new_user = Synapsis::User.create(user_params)

          bank_params = {
            username: 'WRONG USERNAME',
            password: 'test1234',
            pin: '1234',
            oauth_consumer_key: new_user.access_token,
            bank: 'Regions North Carolina',
            mfa: 'test_answer'
          }

          new_bank = Synapsis::Bank.link(bank_params)

          expect(new_bank.class).to eq Synapsis::Error
          expect(new_bank.reason).to be_a_kind_of String
        end

        it 'bad password returns a SynapsisError' do
          new_user = Synapsis::User.create(user_params)

          bank_params = {
            username: 'synapse_good',
            password: 'WRONG PASSWORD',
            pin: '1234',
            oauth_consumer_key: new_user.access_token,
            bank: 'US Bank',
            mfa: 'test_answer'
          }

          new_bank = Synapsis::Bank.link(bank_params)

          expect(new_bank.class).to eq Synapsis::Error
          expect(new_bank.reason).to be_a_kind_of String
        end

        it 'bad mfa answer returns a SynapsisError' do
          new_user = Synapsis::User.create(user_params)

          bank_params = {
            username: 'synapse_good',
            password: 'test1234',
            oauth_consumer_key: new_user.access_token,
            bank: 'Regions Kentucky',
            mfa: 'WRONG MFA ANSWER'
          }

          new_bank = Synapsis::Bank.link(bank_params)

          expect(new_bank.class).to eq Synapsis::Error
          expect(new_bank.reason).to be_a_kind_of String
        end

        xit 'bad PIN returns a SynapsisError--pending since trying test data with a wrong PIN still completes the linking process' do
          new_user = Synapsis::User.create(user_params)

          bank_params = {
            username: 'synapse_good',
            password: 'test1234',
            pin: 'WRONG PIN',
            oauth_consumer_key: new_user.access_token,
            bank: 'USAA',
            mfa: 'test_answer'
          }

          new_bank = Synapsis::Bank.link(bank_params)

          expect(new_bank.class).to eq Synapsis::Error
          expect(new_bank.reason).to be_a_kind_of String
        end
      end
    end
  end
end
