require 'spec_helper'

RSpec.describe PortNumber do
  describe 'getting information about a number' do
    let(:action) { PortNumber.get id, params }
    let(:id) { 1234 }
    let(:params) { {} }

    around do |example|
      VCR.use_cassette('resources/port_number/get') do
        example.run
      end
    end

    it 'makes the request to phaxio' do
      expect_api_request :get, "port_numbers/#{id}", params
      action
    end

    it 'returns a port number object' do
      result = action
      expect(result).to be_a(PortNumber)
    end
  end
end
