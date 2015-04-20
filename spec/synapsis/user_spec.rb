require 'spec_helper'

RSpec.describe Synapsis::User do
  it 'connects' do
    user_params = {
      email: Faker::Internet.email,
      fullname: Faker::Name.name,
      phonenumber: Faker::PhoneNumber.phone_number,
      password: '5ourcep4d',
      ip_address: '8.8.8.8'
    }

    response = Synapsis::User.create(user_params)

    expect(JSON.parse(response.body)['success']).to eq true
    expect(JSON.parse(response.body)['reason']).to eq 'Profile created.'
  end

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
