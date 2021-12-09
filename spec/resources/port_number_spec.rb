require 'spec_helper'

RSpec.describe PortNumber do
  describe 'getting information about a number', vcr: 'port_number/get' do
    let(:action) { PortNumber.get id, params }
    let(:id) { 
      PortOrder.create(
        port_numbers: [TEST_NUMBER],
        contact_number: TEST_NUMBER,
        contact_email: 'julien@phaxio.com',
        account_identifier: '1234',
        name_on_account: 'THIS IS A TEST',
        provider_name: 'DO NOT PORT --Julien',
        has_bill: true,
        legal_agreement: true,
        port_type: 'residential',
        esig: 'NOT A VALID SIGNATURE'
      ).port_numbers[0].id
    }
    let(:params) { {} }

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
