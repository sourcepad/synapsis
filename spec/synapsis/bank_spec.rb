require 'spec_helper'

RSpec.describe Synapsis::Bank do
  context '#add' do
    it 'connects' do
      bank_params = {
        fullname: 'Lori Mcclure',
        account_num: '1111111112',
        routing_num: '121000358',
        nickname: 'Sourcepad Bank',
        oauth_consumer_key: 'c7eda20ff7b2554c0bed2ad596ac5dfeb33124e1',
        account_type: '1',
        account_class: '1'
      }

      response = Synapsis::Bank.add(bank_params)

      expect(JSON.parse(response.body)['bank']['name_on_account']).to eq bank_params[:fullname]
      expect(JSON.parse(response.body)['bank']['nickname']).to eq bank_params[:nickname]
    end
  end
end
