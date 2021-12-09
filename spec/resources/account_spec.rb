require 'spec_helper'

RSpec.describe Account do
  describe 'getting account information', vcr: 'account/get' do
    let(:action) { Account.get params }
    let(:params) { {} }

    it 'sends the request to Phaxio' do
      expect_api_request :get, 'account/status', params
      action
    end

    it 'returns an account object' do
      result = action
      expect(result).to be_a(Account)
    end
  end
end
