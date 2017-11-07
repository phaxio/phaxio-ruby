require 'spec_helper'

RSpec.describe Fax do
  let(:test_file) { File.open test_file_path }
  let(:test_file_path) { File.expand_path(File.join('..', '..', 'support', 'files', 'test.pdf'), __FILE__) }
  let(:test_recipient_number) { ENV.fetch 'TEST_RECIPIENT_NUMBER' }

  describe 'creating a fax' do
    let(:action) { Fax.create params }
    let(:params) { {to: test_recipient_number, file: test_file} }

    around(:each) do |example|
      VCR.use_cassette('resources/fax/create') do
        example.run
      end
    end

    it 'makes the request to Phaxio' do
      expect_api_request :post, 'faxes', to: test_recipient_number, file: test_file
      action
    end

    it 'returns a reference to the fax' do
      result = action
      expect(result).to be_a(Fax::Reference)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe 'retrieving a fax' do
    let(:action) { Fax.get fax_id, params }
    let(:fax_id) { 1234 }
    let(:params) { {} }

    around(:each) do |example|
      VCR.use_cassette('resources/fax/get') do
        example.run
      end
    end

    it 'makes the request to Phaxio' do
      expect_api_request :get, "faxes/#{fax_id}", params
      action
    end

    it 'returns a fax' do
      result = action
      expect(result).to be_a(Fax)
      expect(result.id).to eq(fax_id)
    end
  end

  # TODO: Refactor this
  # This one's a little tricky, since it relies on having a fax to cancel.
  describe 'cancelling a fax' do
    let(:action) { Fax.cancel @fax_id, params }
    let(:params) { {} }

    before do
      VCR.use_cassette('resources/fax/create') do
        @fax_id = Fax.create(to: test_recipient_number, file: test_file).id
      end
    end

    around(:each) do |example|
      VCR.use_cassette('resources/fax/cancel') do
        example.run
      end
    end

    it 'makes the request to Phaxio' do
      expect_api_request :post, "faxes/#{@fax_id}/cancel", params
      action
    end

    it 'returns a reference to the fax' do
      result = action
      expect(result).to be_a(Fax::Reference)
      expect(result.id).to eq(@fax_id)
    end
  end

  describe 'listing faxes' do
    let(:action) { Fax.list params }
    let(:params) { {created_before: time} }
    let(:time) { Time.new 2017, 10, 28, 0, 17, 0, 0 }

    around do |example|
      VCR.use_cassette('resources/fax/list') do
        example.run
      end
    end

    it 'sends the request to phaxio' do
      expect_api_request :get, 'faxes', params
      action
    end

    it 'returns a collection of faxes' do
      result = action
      expect(result).to be_a(Fax::Collection)
    end
  end

  describe 'resending a fax' do
    let(:action) { Fax.resend fax_id, params }
    let(:fax_id) { 1234 }
    let(:params) { {} }

    around do |example|
      VCR.use_cassette('resources/fax/resend') do
        example.run
      end
    end

    it 'makes the request to Phaxio' do
      expect_api_request :post, "faxes/#{fax_id}/resend", params
      action
    end

    it 'returns a reference to a new fax' do
      result = action
      expect(result).to be_a(Fax::Reference)
      expect(result.id).to_not eq(fax_id)
    end
  end

  describe 'deleting a fax' do
    let(:action) { Fax.delete fax_id, params }
    let(:fax_id) { 1234 }
    let(:params) { {} }

    around do |example|
      VCR.use_cassette('resources/fax/delete') do
        example.run
      end
    end

    it 'makes the request to Phaxio' do
      expect_api_request :delete, "faxes/#{fax_id}", params
      action
    end

    it 'returns true' do
      result = action
      expect(result).to eq(true)
    end
  end

  describe 'deleting a fax file' do
    let(:action) { Fax.delete_file fax_id, params }
    let(:fax_id) { 1234 }
    let(:params) { {} }

    around do |example|
      VCR.use_cassette('resources/fax/delete_file') do
        example.run
      end
    end

    it 'makes the request to Phaxio' do
      expect_api_request :delete, "faxes/#{fax_id}/file", params
      action
    end

    it 'returns true' do
      result = action
      expect(result).to eq(true)
    end
  end

  describe 'downloading a fax file' do
    let(:action) { Fax.file fax_id, params }
    let(:fax_id) { 1234 }
    let(:params) { {} }

    around do |example|
      VCR.use_cassette('resources/fax/file') do
        example.run
      end
    end

    it 'makes the request to phaxio' do
      expect_api_request :get, "faxes/#{fax_id}/file", params
      action
    end

    it 'returns a file' do
      result = action
      expect(result).to be_a(File)
    end
  end

  describe 'receiving a test fax' do
    let(:action) { Fax.test_receive params }
    let(:params) { {file: test_file} }

    around do |example|
      VCR.use_cassette('resources/fax/test_receive') do
        example.run
      end
    end

    it 'makes the request to Phaxio' do
      expect_api_request :post, 'faxes', {file: test_file, direction: 'received'}
      action
    end

    it 'returns true' do
      result = action
      expect(result).to eq(true)
    end
  end

  describe 'getting a list of supported countries' do
    let(:action) { Fax.supported_countries }
    let(:params) { {} }

    around do |example|
      VCR.use_cassette('resources/fax/supported_countries') do
        example.run
      end
    end

    it 'makes the request to Phaxio' do
      expect_api_request :get, 'public/countries', params
      action
    end

    it 'returns a collection of supported country resources' do
      result = action
      expect(result).to be_a(Phaxio::Resource::Collection)
    end
  end

  describe Fax::Reference do
    let(:fax_id) { 1234 }

    it 'gets the full fax' do
      VCR.use_cassette('resources/fax/get') do
        reference = Fax::Reference.new fax_id
        result = reference.get
        expect(result).to be_a(Fax)
        expect(result.id).to eq(1234)
      end
    end
  end
end
