require 'spec_helper'

RSpec.describe Fax do
  around(:each) do |example|
    VCR.use_cassette('resources/fax') do
      example.run
    end
  end

  describe 'creating a fax' do
    let(:action) { Fax.create params, options }
    let(:params) { {to: '+12258675309', file: test_file} }
    let(:options) { {} }
    let(:test_file) { File.open test_file_path }
    let(:test_file_path) { File.expand_path(File.join(%w(.. .. support files test.pdf)), __FILE__) }

    it 'makes the request to Phaxio' do
      expect_api_request(:post, Fax::CREATE_FAX_ENDPOINT, {to: '+12258675309', file: test_file}, {})
      action
    end

    it 'returns a reference to the fax' do
      result = action
      expect(result).to be_a(Fax::Reference)
      expect(result.id).to be_a(Fixnum)
    end
  end
end
