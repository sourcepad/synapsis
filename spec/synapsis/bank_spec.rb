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

  context '#add' do
    it 'adds a bank account' do
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
        fullname: new_user.fullname,
        account_num: '1111111112',
        routing_num: '121000358',
        nickname: 'Sourcepad Bank',
        oauth_consumer_key: new_user.access_token,
        account_type: Synapsis::Bank::AccountType::CHECKING,
        account_class: Synapsis::Bank::AccountClass::PERSONAL
      }

      new_bank = Synapsis::Bank.add(bank_params)

      expect(new_bank.is_active).to eq true
      expect(new_bank.name_on_account).to eq user_params[:fullname]
      expect(new_bank.nickname).to eq bank_params[:nickname]
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

      new_bank = Synapsis::Bank.add(bank_params)

      expect(new_bank.class).to eq Synapsis::Error
      expect(new_bank.reason).to be_a_kind_of String
    end
  end

  context '#link' do
    it 'adds a bank account' do
      user_params = {
        email: Faker::Internet.email,
        fullname: Faker::Name.name,
        phonenumber: Faker::PhoneNumber.phone_number,
        password: '5ourcep4d',
        ip_address: '8.8.8.8'
      }

      new_user = Synapsis::User.create(user_params)

      bank_params = {
        username: 'synapse_good',
        password: 'test1234',
        pin: '1234',
        oauth_consumer_key: new_user.access_token,
        bank: 'Wells Fargo',
        mfa: 'test_answer'
      }

      new_bank = Synapsis::Bank.link(bank_params)

      expect(new_bank.is_active).to eq true
      expect(new_bank.name_on_account).to eq user_params[:fullname]
      expect(new_bank.bank_name).to eq bank_params[:bank]
    end
  end
end
