require 'spec_helper'

RSpec.describe PhoneNumber do
  describe PhoneNumber::Reference, vcr: 'phone_number/reference' do
    describe '#get' do
      it 'returns information about the referenced number' do
        reference = PhoneNumber::Reference.new TEST_NUMBER
        result = reference.get
        expect(result).to be_a(PhoneNumber)
        expect(result.phone_number).to eq(TEST_NUMBER)
      end
    end
  end

  describe 'provisioning a number', vcr: 'phone_number/create' do
    let(:action) { PhoneNumber.create params }
    let(:params) { {country_code: 1, area_code: 225} }

    it 'makes the request to Phaxio' do
      expect_api_request :post, 'phone_numbers', params
      action
    end

    it 'returns a phone number object' do
      result = action
      expect(result).to be_a(PhoneNumber)
    end
  end

  describe 'getting information about a number', vcr: 'phone_number/get' do
    let(:action) { PhoneNumber.get phone_number, params }
    let(:phone_number) { TEST_NUMBER }
    let(:params) { {} }

    it 'makes the request to Phaxio' do
      expect_api_request :get, "phone_numbers/#{phone_number}"
      action
    end

    it 'returns a phone number object' do
      result = action
      expect(result).to be_a(PhoneNumber)
    end
  end

  describe 'listing numbers', vcr: 'phone_number/list' do
    let(:action) { PhoneNumber.list params }
    let(:params) { {} }

    it 'makes the request to Phaxio' do
      expect_api_request :get, 'phone_numbers', params
      action
    end

    it 'returns a collection of phone number objects' do
      result = action
      expect(result).to be_a(Phaxio::Resource::Collection)
    end
  end

  describe 'releasing a number', vcr: 'phone_number/release' do
    let(:action) { PhoneNumber.release phone_number, params }
    let(:phone_number) {
      PhoneNumber.provision(country_code: 1, area_code: 225).phone_number
    }
    let(:params) { {} }

    it 'sends the request to Phaxio' do
      expect_api_request :delete, "phone_numbers/#{phone_number}", params
      action
    end

    it 'returns true' do
      result = action
      expect(result).to eq(true)
    end
  end
end
