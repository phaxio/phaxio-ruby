require 'spec_helper'

RSpec.describe Account do
  describe 'getting account information' do
    let(:action) { Account.get params }
    let(:params) { {} }

    around do |example|
      VCR.use_cassette('resources/account/status') do
        example.run
      end
    end

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
