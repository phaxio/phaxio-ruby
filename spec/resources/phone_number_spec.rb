require 'spec_helper'

RSpec.describe PhoneNumber do
  describe 'provisioning a number' do
    let(:action) { PhoneNumber.create params }
    let(:params) { {country_code: 1, area_code: 225} }

    around do |example|
      VCR.use_cassette('resources/phone_number/create') do
        example.run
      end
    end

    it 'makes the request to Phaxio' do
      expect_api_request :post, 'phone_numbers', params
      action
    end

    it 'returns a phone number object' do
      result = action
      expect(result).to be_a(PhoneNumber)
    end
  end

  describe 'getting information about a number' do
    let(:action) { PhoneNumber.get phone_number, params }
    let(:phone_number) { '12258675309' }
    let(:params) { {} }

    around do |example|
      VCR.use_cassette('resources/phone_number/get') do
        example.run
      end
    end

    it 'makes the request to Phaxio' do
      expect_api_request :get, "phone_numbers/#{phone_number}"
      action
    end

    it 'returns a phone number object' do
      result = action
      expect(result).to be_a(PhoneNumber)
    end
  end

  describe 'listing numbers' do
    let(:action) { PhoneNumber.list params }
    let(:params) { {} }

    around do |example|
      VCR.use_cassette('resources/phone_number/list') do
        example.run
      end
    end

    it 'makes the request to Phaxio' do
      expect_api_request :get, 'phone_numbers', params
      action
    end

    it 'returns a collection of phone number objects' do
      result = action
      expect(result).to be_a(Phaxio::Resource::Collection)
    end
  end

  describe 'releasing a number' do
    let(:action) { PhoneNumber.release phone_number, params }
    let(:phone_number) { '+12258675309' }
    let(:params) { {} }

    around do |example|
      VCR.use_cassette('resources/phone_number/release') do
        example.run
      end
    end

    it 'sends the request to Phaxio' do
      expect_api_request :delete, "phone_numbers/#{phone_number}", params
      action
    end

    it 'returns true' do
      result = action
      expect(result).to eq(true)
    end
  end

  describe 'listing area codes available for purchasing numbers' do
    let(:action) { PhoneNumber.list_available_area_codes params }
    let(:params) { {} }

    around do |example|
      VCR.use_cassette('resources/phone_number/list_available_area_codes') do
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
