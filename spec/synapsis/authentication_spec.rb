require 'spec_helper'

RSpec.describe Synapsis::Authentication do
  it 'connects' do
    authentication_params = {
      # username: 'natalia@zulaufboyer.name',
      username: 'b84b8c816c0541f09ea9fbd7c5d8e4',
      password: '5ourcep4d'
    }

    response = Synapsis::Authentication.login(authentication_params)

    expect(JSON.parse(response.body)['access_token']).to be_truthy
    expect(JSON.parse(response.body)['token_type']).to eq 'Bearer'
  end
end
