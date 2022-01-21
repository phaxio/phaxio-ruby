require 'spec_helper'

RSpec.describe PortOrder do
  describe 'creating an order', vcr: 'port_order/create' do
    let(:action) { PortOrder.create params }
    let(:params) {
      {
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
      }
    }

    it 'makes the request to Phaxio' do
      expect_api_request :post, 'port_orders', params
      action
    end

    it 'returns a port order object' do
      result = action
      expect(result).to be_a(PortOrder)
    end
  end
  
  describe 'getting information about an order', vcr: 'port_order/get' do
    let(:action) { PortOrder.get id, params }
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
      ).id
    }
    let(:params) { {} }

    it 'makes the request to Phaxio' do
      expect_api_request :get, "port_orders/#{id}", params
      action
    end

    it 'returns a port order object' do
      result = action
      expect(result).to be_a(PortOrder)
    end
  end

  describe 'listing port orders', vcr: 'port_order/list' do
    let(:action) { PortOrder.list params }
    let(:params) { {} }

    it 'makes the request to Phaxio' do
      expect_api_request :get, 'port_orders', params
      action
    end

    it 'returns a collection of port order objects' do
      result = action
      expect(result).to be_a(Phaxio::Resource::Collection)
      expect(result.first).to be_a(PortOrder)
    end
  end
end
