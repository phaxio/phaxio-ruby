require 'spec_helper'

RSpec.describe PortOrder do
  describe 'creating an order' do
    let(:action) { PortOrder.create params }
    let(:params) {
      {
        port_numbers: ['+12251231234'],
        contact_number: '+12251231234',
        name_on_account: 'THIS IS A TEST',
        provider_name: 'DO NOT PORT --Julien',
        has_bill: true,
        legal_agreement: true,
        esig: 'NOT A VALID SIGNATURE'
      }
    }

    around do |example|
      VCR.use_cassette('resources/port_order/create') do
        example.run
      end
    end

    it 'makes the request to Phaxio' do
      expect_api_request :post, 'port_orders', params
      action
    end

    it 'returns a port order object' do
      result = action
      expect(result).to be_a(PortOrder)
    end
  end
  
  describe 'getting information about an order' do
    let(:action) { PortOrder.get id, params }
    let(:id) { 1234 }
    let(:params) { {} }

    around do |example|
      VCR.use_cassette('resources/port_order/get') do
        example.run
      end
    end

    it 'makes the request to Phaxio' do
      expect_api_request :get, "port_orders/#{id}", params
      action
    end

    it 'returns a port order object' do
      result = action
      expect(result).to be_a(PortOrder)
    end
  end

  describe 'listing port orders' do
    let(:action) { PortOrder.list params }
    let(:params) { {} }

    around do |example|
      VCR.use_cassette('resources/port_order/list') do
        example.run
      end
    end

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
