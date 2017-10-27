require 'spec_helper'

RSpec.describe Fax do
  let(:test_file) { File.open test_file_path }
  let(:test_file_path) { File.expand_path(File.join('..', '..', 'support', 'files', 'test.pdf'), __FILE__) }
  let(:test_recipient_number) { ENV.fetch 'TEST_RECIPIENT_NUMBER' }

  describe 'creating a fax' do
    let(:action) { Fax.create params, options }
    let(:params) { {to: test_recipient_number, file: test_file} }
    let(:options) { {} }

    around(:each) do |example|
      VCR.use_cassette('resources/fax/create') do
        example.run
      end
    end

    it 'makes the request to Phaxio' do
      expect_api_request :post, 'faxes', {to: test_recipient_number, file: test_file}, {}
      action
    end

    it 'returns a reference to the fax' do
      result = action
      expect(result).to be_a(Fax::Reference)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe 'retrieving a fax' do
    let(:action) { Fax.get @fax_id, options }
    let(:options) { {} }

    before do
      VCR.use_cassette('resources/fax/create') do
        @fax_id = Fax.create({to: test_recipient_number, file: test_file}).id
      end
    end

    around(:each) do |example|
      VCR.use_cassette('resources/fax/get') do
        example.run
      end
    end

    it 'makes the request to Phaxio' do
      expect_api_request :get, "faxes/#{@fax_id}", {}, {}
      action
    end

    it 'returns a fax' do
      result = action
      expect(result).to be_a(Fax)
      expect(result.id).to eq(@fax_id)
    end
  end

  # This one's a little tricky, since it relies on having a fax to cancel.
  describe 'cancelling a fax' do
    let(:action) { Fax.cancel @fax_id, options }
    let(:options) { {} }

    before do
      VCR.use_cassette('resources/fax/create') do
        @fax_id = Fax.create({to: test_recipient_number, file: test_file}).id
      end
    end

    around(:each) do |example|
      VCR.use_cassette('resources/fax/cancel') do
        example.run
      end
    end

    it 'makes the request to Phaxio' do
      expect_api_request :post, "faxes/#{@fax_id}/cancel"
      action
    end

    it 'returns a reference to the fax' do
      result = action
      expect(result).to be_a(Fax::Reference)
      expect(result.id).to eq(@fax_id)
    end
  end
end
