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
      context 'happy path' do
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

          expect(new_bank.banks.first.name_on_account.downcase).to eq user_params[:fullname].downcase
          expect(new_bank.banks.first.bank_name).to eq bank_params[:bank]
        end
      end

      context 'errors' do
        it 'bad username raises a SynapsisError' do
          new_user = Synapsis::User.create(user_params)

          bank_params = {
            username: 'WRONG USERNAME',
            password: 'test1234',
            pin: '1234',
            oauth_consumer_key: new_user.access_token,
            bank: 'Regions North Carolina',
            mfa: 'test_answer'
          }

          expect{ Synapsis::Bank.link(bank_params) }.to raise_error(Synapsis::Error).with_message('The input you have entered is not valid. Please check your entry and try again.')
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

          expect{ Synapsis::Bank.link(bank_params) }.to raise_error(Synapsis::Error).with_message('Wrong MFA answer.')
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

    context 'code-based MFA' do
      it 'adds a bank account' do
        new_user = Synapsis::User.create(user_params)

        bank_params = {
          username: 'synapse_code',
          password: 'test1234',
          oauth_consumer_key: new_user.access_token,
          bank: 'Ally',
          mfa: 'test_answer'
        }

        new_bank = Synapsis::Bank.link(bank_params)

        expect(new_bank.banks.first.name_on_account).to eq 'Test User' # Synapse returns Test User
        expect(new_bank.banks.first.bank_name).to eq bank_params[:bank]
      end

      context 'errors' do
        it 'bad username returns a SynapsisError--generic error (used Chase as an example)' do
          new_user = Synapsis::User.create(user_params)

          bank_params = {
            username: 'WRONG USERNAME',
            password: 'test1234',
            pin: '1234',
            oauth_consumer_key: new_user.access_token,
            bank: 'Chase',
            mfa: 'test_answer'
          }

          expect { Synapsis::Bank.link(bank_params) }.to raise_error(Synapsis::Error).with_message('The username or password provided were not correct.')
        end

        it 'bad username returns a SynapsisError--Ally bank specific error message' do
          new_user = Synapsis::User.create(user_params)

          bank_params = {
            username: 'WRONG USERNAME',
            password: 'test1234',
            pin: '1234',
            oauth_consumer_key: new_user.access_token,
            bank: 'Ally',
            mfa: 'test_answer'
          }

          expect { Synapsis::Bank.link(bank_params) }.to raise_error(Synapsis::Error).with_message('Problems logging in? You can go to the online banking login page at allybank.com and select Forgot Your Username or call us 24/7 for help. Mobile banking is not available to Ally Auto or Mortgage customers at this time.')
        end

        it 'bad mfa answer returns a SynapsisError' do
          new_user = Synapsis::User.create(user_params)

          bank_params = {
            username: 'synapse_code',
            password: 'test1234',
            oauth_consumer_key: new_user.access_token,
            bank: 'Chase',
            mfa: 'WRONG MFA ANSWER'
          }

          expect { Synapsis::Bank.link(bank_params) }.to raise_error(Synapsis::Error).with_message('Wrong MFA answer.')
        end
      end
    end

    context 'no MFA' do
      context 'happy path' do
        it 'adds a bank account' do
          new_user = Synapsis::User.create(user_params)

          bank_params = {
            username: 'synapse_nomfa',
            password: 'test1234',
            oauth_consumer_key: new_user.access_token,
            bank: 'Capital One 360'
          }

          new_bank = Synapsis::Bank.link(bank_params)

          # Upcase since Synapse automatically downcases titles such as "MD, PHD" (it becomes Md or Phd)
          expect(new_bank.banks.first.name_on_account.upcase).to eq 'TEST USER'
          expect(new_bank.banks.first.bank_name).to eq bank_params[:bank]
        end
      end

      context 'errors' do
        it 'bad username returns a SynapsisError' do
          new_user = Synapsis::User.create(user_params)

          bank_params = {
            username: 'WRONG USERNAME',
            password: 'test1234',
            oauth_consumer_key: new_user.access_token,
            bank: 'Capital One 360'
          }

          expect { Synapsis::Bank.link(bank_params) }.to raise_error(Synapsis::Error).with_message('The username or password provided were not correct.')
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

          expect { Synapsis::Bank.link(bank_params) }.to raise_error(Synapsis::Error).with_message('Wrong MFA answer.')
        end
      end
    end

    context 'multiple bank linkages' do
      xit 'works' do
        new_user = Synapsis::User.create(user_params)

        first_bank_params = {
          username: 'synapse_code',
          password: 'test1234',
          oauth_consumer_key: new_user.access_token,
          bank: 'Ally',
          mfa: 'test_answer'
        }

        first_bank = Synapsis::Bank.new(first_bank_params).link

        expect(first_bank.name_on_account).to eq user_params[:fullname]
        expect(first_bank.bank_name).to eq first_bank_params[:bank]

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

        second_bank_params = {
          username: 'synapse_good',
          password: 'test1234',
          oauth_consumer_key: new_user.access_token,
          bank: 'PNC',
          mfa: 'test_answer'
        }

        second_bank = Synapsis::Bank.new(second_bank_params).link

        expect(second_bank.name_on_account).to eq user_params[:fullname]
        expect(second_bank.bank_name).to eq second_bank_params[:bank]

      end
    end
  end
end
