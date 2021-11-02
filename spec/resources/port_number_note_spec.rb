require 'spec_helper'

RSpec.describe PortNumberNote do
  describe 'getting a list of notes' do
    let(:action) { PortNumberNote.get port_number_id, params }
    let(:port_number_id) { 1234 }
    let(:params) { {} }

    around do |example|
      VCR.use_cassette('resources/port_number_note/get') do
        example.run
      end
    end

    it 'makes the request to phaxio' do
      expect_api_request :get, "port_numbers/#{id}/notes", params
      action
    end

    it 'returns a collection of port number note objects' do
      result = action
      expect(result).to be_a(Phaxio::Resource::Collection)
      expect(result.first).to be_a(PortNumberNote)
    end
  end
end
