require 'spec_helper'

RSpec.describe Fax do
  let(:test_file) { File.open test_file_path }
  let(:test_file_path) { File.join File.expand_path('..', __dir__), 'support', 'files', 'test.pdf' }
  let(:test_recipient_number) { TEST_NUMBER }

  describe 'creating a fax', vcr: 'fax/create' do
    let(:action) { Fax.create params }
    let(:params) { {to: test_recipient_number, file: test_file} }

    it 'makes the request to Phaxio' do
      expect_api_request :post, 'faxes', to: test_recipient_number, file: test_file
      action
    end

    it 'returns a reference to the fax' do
      result = action
      expect(result).to be_a(Fax::Reference)
      expect(result.id).to be_a(Integer)
    end
  end

  describe 'retrieving a fax', vcr: 'fax/get' do
    let(:action) { Fax.get fax_id, params }
    let(:fax_id) { Fax.create(to: test_recipient_number, file: test_file).id }
    let(:params) { {} }

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

  describe 'cancelling a fax', vcr: 'fax/cancel' do
    let(:action) { Fax.cancel fax_id, params }
    let(:fax_id) { Fax.create(to: test_recipient_number, file: test_file).id }
    let(:params) { {} }

    it 'makes the request to Phaxio' do
      expect_api_request :post, "faxes/#{fax_id}/cancel", params
      action
    end

    it 'returns a reference to the fax' do
      result = action
      expect(result).to be_a(Fax::Reference)
      expect(result.id).to eq(fax_id)
    end
  end

  describe 'listing faxes', vcr: 'fax/list' do
    let(:action) { Fax.list params }
    let(:params) { {created_before: time} }
    let(:time) { Time.new 2017, 10, 28, 0, 17, 0, 0 }

    it 'sends the request to phaxio' do
      expect_api_request :get, 'faxes', params
      action
    end

    it 'returns a collection of faxes' do
      result = action
      expect(result).to be_a(Fax::Collection)
    end
  end

  describe 'resending a fax', vcr: 'fax/resend' do
    let(:action) { Fax.resend fax_id, params }
    let(:fax_id) {
      fax_id = Fax.create(to: test_recipient_number, file: test_file).id
      sleep 30 if VCR.current_cassette.recording?
      fax_id
    }
    let(:params) { {} }

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

  describe 'deleting a fax', vcr: 'fax/delete' do
    let(:action) { Fax.delete fax_id, params }
    let(:fax_id) {
      fax_id = Fax.create(to: test_recipient_number, file: test_file).id
      sleep 30 if VCR.current_cassette.recording?
      fax_id
    }
    let(:params) { {} }

    it 'makes the request to Phaxio' do
      expect_api_request :delete, "faxes/#{fax_id}", params
      action
    end

    it 'returns true' do
      result = action
      expect(result).to eq(true)
    end
  end

  describe 'deleting a fax file', vcr: 'fax/delete_file' do
    let(:action) { Fax.delete_file fax_id, params }
    let(:fax_id) {
      fax_id = Fax.create(to: test_recipient_number, file: test_file).id
      sleep 30 if VCR.current_cassette.recording?
      fax_id
    }
    let(:params) { {} }

    it 'makes the request to Phaxio' do
      expect_api_request :delete, "faxes/#{fax_id}/file", params
      action
    end

    it 'returns true' do
      result = action
      expect(result).to eq(true)
    end
  end

  describe 'downloading a fax file', vcr: 'fax/file' do
    let(:action) { Fax.file fax_id, params }
    let(:fax_id) {
      fax_id = Fax.create(to: test_recipient_number, file: test_file).id
      sleep 30 if VCR.current_cassette.recording?
      fax_id
    }
    let(:params) { {} }

    it 'makes the request to phaxio' do
      expect_api_request :get, "faxes/#{fax_id}/file", params
      action
    end

    it 'returns a file' do
      result = action
      expect(result).to be_a(File)
    end
  end

  describe 'receiving a test fax', vcr: 'fax/test_receive' do
    let(:action) { Fax.test_receive params }
    let(:params) { {file: test_file} }

    it 'makes the request to Phaxio' do
      expect_api_request :post, 'faxes', {file: test_file, direction: 'received'}
      action
    end

    it 'returns true' do
      result = action
      expect(result).to eq(true)
    end
  end

  describe Fax::Reference, vcr: 'fax/reference' do
    let(:fax_id) { Fax.create(to: test_recipient_number, file: test_file).id }

    it 'gets the full fax' do
      reference = Fax::Reference.new fax_id
      result = reference.get
      expect(result).to be_a(Fax)
      expect(result.id).to eq(fax_id)
    end
  end
end
