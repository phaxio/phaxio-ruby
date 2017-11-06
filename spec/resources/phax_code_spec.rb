require 'spec_helper'

RSpec.describe PhaxCode do
  describe 'creating a phax code' do
    let(:action) { PhaxCode.create params, options }
    let(:params) { {metadata: 'This is a test PhaxCode'} }
    let(:options) { {} }

    around do |example|
      VCR.use_cassette('resources/phax_code/create') do
        example.run
      end
    end

    it 'makes the request to phaxio' do
      expect_api_request :post, 'phax_codes', params, options
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
end