require 'spec_helper'

RSpec.describe Synapsis::User do
  describe '#create' do
    it 'creates a user account and returns the SynapsePay username, access_token and refresh_token' do
      user_email = Faker::Internet.email[0, 29] # Limit 30 characters

      user_params = {
        email: user_email,
        fullname: user_email,
        phonenumber: Faker::PhoneNumber.phone_number,
        password: '5ourcep4d',
        ip_address: '8.8.8.8'
      }

      new_synapse_user = Synapsis::User.create(user_params)

      ['access_token', 'oauth_consumer_key', 'expires_in',
       'reason', 'refresh_token', 'success', 'username', 'user_id'].each do |k|
        expect(new_synapse_user.send(k)).not_to be_nil
      end
    end

    it 'returns an error if the params are bad' do
      user_params = {
        email: "1",
        fullname: "",
        phonenumber: Faker::PhoneNumber.phone_number,
        password: '5ourcep4d',
        ip_address: '8.8.8.8'
      }

      expect { Synapsis::User.create(user_params) }.to raise_error(Synapsis::Error).with_message('Add full name to create an account')
    end
  end

  describe '#edit' do
    it 'edits the user' do
      oauth_token = 'c7eda20ff7b2554c0bed2ad596ac5dfeb33124e1'
      edit_user_attributes = {
        'fullname' => Faker::Name.name,
        'oauth_consumer_key' => oauth_token
      }

      edited_user = Synapsis::User.edit(edit_user_attributes)

      expect(edited_user.fullname).to eq edit_user_attributes['fullname']
    end

    it 'returns an error if the update didnt work' do
      oauth_token = 'WRONG_OAUTH_TOKEN'
      edit_user_attributes = {
        'fullname' => Faker::Name.name,
        'oauth_consumer_key' => oauth_token
      }

      expect { Synapsis::User.edit(edit_user_attributes) }.to raise_error(Synapsis::Error).with_message('Error in OAuth Authentication.')
    end
  end

  describe '#view' do
    context 'happy path' do
      it 'retrieves the user and returns their information in Struct form' do
        oauth_token = 'c7eda20ff7b2554c0bed2ad596ac5dfeb33124e1'
        response = Synapsis::User.view(oauth_token)

        user_attributes = [:accept_gratuity, :balance, :email, :fullname, :has_avatar, :phone_number, :seller_details, :user_id, :username, :visit_count, :visit_message]

        user_attributes.each do |user_attribute|
          expect(response.send(user_attribute)).not_to be_nil
        end
      end
    end

    context 'error' do
      it ' raises an Error' do
        oauth_token = 'WRONG!!!'

        expect { Synapsis::User.view(oauth_token) }.to raise_error(Synapsis::Error).with_message('Error in OAuth Authentication.')
      end
    end
  end
end
