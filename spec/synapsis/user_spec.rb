require 'spec_helper'

RSpec.describe Synapsis::User do
  describe '#create' do
    it 'creates a user account and returns the SynapsePay username, access_token and refresh_token' do
      user_email = Faker::Internet.email

      user_params = {
        email: user_email,
        fullname: user_email,
        phonenumber: Faker::PhoneNumber.phone_number,
        password: '5ourcep4d',
        ip_address: '8.8.8.8'
      }

      new_synapse_user = Synapsis::User.create(user_params)

      expect(new_synapse_user.class).to eq Synapsis::User
      expect(new_synapse_user.email).to eq user_params[:email]
      expect(new_synapse_user.username).to be_a_kind_of String
      expect(new_synapse_user.access_token).to be_a_kind_of String
      expect(new_synapse_user.refresh_token).to be_a_kind_of String
    end
  end

  describe '#view' do
    it 'retrieves the user and returns their information in Struct form' do
      oauth_token = 'c7eda20ff7b2554c0bed2ad596ac5dfeb33124e1'
      response = Synapsis::User.view(oauth_token)

      user_attributes = [:accept_gratuity, :balance, :email, :fullname, :has_avatar, :phone_number, :resource_uri, :seller_details, :user_id, :username, :visit_count, :visit_message]

      user_attributes.each do |user_attribute|
        expect(response.send(user_attribute)).not_to be_nil
      end
    end
  end

  describe 'infrastructure' do
    it 'builds' do
      result = '{"email":"test5@synapsepay.com","fullname":"Test Account","ip_address":"11.111.11.11","phonenumber":"123456789","client_id":"ce65d5ce9116ae4c77bb","client_secret":"41877da204b32dbee3095033069ed81bcf512154"}'

      parsed_result = JSON.parse(result)

      user_params = {
        email: 'test5@synapsepay.com',
        fullname: 'Test Account',
        ip_address: '11.111.11.11',
        phonenumber: '123456789'
      }

      built = JSON.parse(Synapsis::User.new(user_params).build_json_from_params)

      user_params.each do |k, v|
        expect(built[k]).to eq(parsed_result[k])
      end
    end
  end
end
