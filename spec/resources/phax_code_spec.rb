require 'spec_helper'

RSpec.describe PhaxCode do
  describe 'creating a phax code' do
    let(:action) { PhaxCode.create params }
    let(:params) { {metadata: 'This is a test PhaxCode'} }

    around do |example|
      VCR.use_cassette('resources/phax_code/create') do
        example.run
      end
    end

    it 'makes the request to phaxio' do
      expect_api_request :post, 'phax_codes', params
      action
    end

    it 'returns a PhaxCode instance by default' do
      result = action
      expect(result).to be_a(PhaxCode)
    end

    context 'type is specified to be png' do
      let(:params) { {metadata: 'This is a test PhaxCode', type: 'png'} }

      it 'returns a png if type is specified to be png' do
        result = action
        expect(result).to be_a(File)
      end
    end
  end

  describe 'getting a phax code' do
    let(:action) { PhaxCode.get params }
    let(:params) { {} }

    around do |example|
      VCR.use_cassette('resources/phax_code/get') do
        example.run
      end
    end

    it 'makes the request to Phaxio' do
      expect_api_request :get, 'phax_code', params
      action
    end

    context 'getting the default phax code with no type specified' do
      it 'returns a PhaxCode instance' do
        result = action
        expect(result).to be_a(PhaxCode)
      end
    end

    context 'getting the default phax code with png type specified' do
      let(:params) { {type: 'png'} }

      it 'returns a file' do
        result = action
        expect(result).to be_a(File)
      end
    end

    context 'getting a particular phax code with no type specified' do
      let(:params) { {identifier: '-Y3jxX'} }

      it 'returns a PhaxCode instance' do
        result = action
        expect(result).to be_a(PhaxCode)
      end
    end

    context 'getting a particular phax code with png type specified' do
      let(:params) { {identifier: '-Y3jxX', type: 'png'} }

      it 'returns a file' do
        result = action
        expect(result).to be_a(File)
      end
    end
  end
end