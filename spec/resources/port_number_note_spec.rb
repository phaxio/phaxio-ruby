require 'spec_helper'

RSpec.describe PortNumberNote do
  describe 'getting a list of notes', vcr: 'port_number_note/list' do
    let(:action) { PortNumberNote.list port_number_id, params }
    let(:port_number_id) {
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
      expect_api_request :get, "port_numbers/#{port_number_id}/notes", params
      action
    end

    it 'returns a collection of port number note objects' do
      result = action
      expect(result).to be_a(Phaxio::Resource::Collection)
    end
  end
end
