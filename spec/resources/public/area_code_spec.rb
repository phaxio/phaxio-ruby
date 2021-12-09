require 'spec_helper'

RSpec.describe Public::AreaCode do
  describe 'listing area codes available for purchasing numbers', vcr: 'public/area_code/list' do
    let(:action) { Public::AreaCode.list params }
    let(:params) { {} }

    around do |example|
      VCR.use_cassette('resources/public/area_codes/list') do
        example.run
      end
    end

    it 'sends the request to Phaxio' do
      expect_api_request :get, 'public/area_codes', params
      action
    end

    it 'returns a collection of available area codes' do
      result = action
      expect(result).to be_a(Phaxio::Resource::Collection)
    end
  end
end
