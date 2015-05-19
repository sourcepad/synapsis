require 'spec_helper'

RSpec.describe Synapsis::Bank do
  context 'namespacing' do
    it 'has a namespace for both AccountClass and AccountType' do
      expect(Synapsis::Bank::AccountClass::PERSONAL).to eq 1
      expect(Synapsis::Bank::AccountClass::BUSINESS).to eq 2

      expect(Synapsis::Bank::AccountType::CHECKING).to eq 1
      expect(Synapsis::Bank::AccountType::SAVINGS).to eq 2
    end
  end

  context '#add/ #remove' do
    it 'adds and removes a bank account' do
      random_persons_access_token = 'dcd234d9d9fb55ad9711c4c41e254868ef3768d4'

      viewed_user = Synapsis::User.view(random_persons_access_token)

      bank_params = {
        fullname: viewed_user.user.fullname,
        account_num: '1111111112',
        routing_num: '121000358',
        nickname: 'Sourcepad Bank',
        oauth_consumer_key: random_persons_access_token,
        account_type: Synapsis::Bank::AccountType::CHECKING,
        account_class: Synapsis::Bank::AccountClass::PERSONAL
      }

      new_bank = Synapsis::Bank.add(bank_params)
      expect(new_bank.bank.name_on_account).to eq viewed_user.user.fullname
      expect(new_bank.bank.nickname.downcase).to eq bank_params[:nickname].downcase

      removed_bank = Synapsis::Bank.remove(new_bank.bank.id, random_persons_access_token)

      expect(removed_bank.success).to eq true
    end

    it 'adds a bank account (errors)' do
      # We need to create a user because Synapse limits bank accounts to 5 per user.
      user_params = {
        email: Faker::Internet.email,
        fullname: Faker::Name.name,
        phonenumber: Faker::PhoneNumber.phone_number,
        password: '5ourcep4d',
        ip_address: '8.8.8.8'
      }

      new_user = Synapsis::User.create(user_params)

      bank_params = {
        fullname: 'NOT THE GUY',
        account_num: '1111111112',
        routing_num: '121000358',
        nickname: 'Sourcepad Bank',
        oauth_consumer_key: new_user.access_token,
        account_type: Synapsis::Bank::AccountType::CHECKING,
        account_class: Synapsis::Bank::AccountClass::PERSONAL
      }

      expect { Synapsis::Bank.add(bank_params) }.to raise_error(Synapsis::Error).with_message('Because of security reasons you can only add a bank account that belongs to you and is in your name.')
    end
  end
end
