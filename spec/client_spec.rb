require 'spec_helper'

RSpec.describe Phaxio::Client do
  subject(:client) { Phaxio::Client }

  describe 'making a request' do
    it 'uses the configured API key and secret by default' do
      expect(RestClient).to receive(:get) do |_url, rest_client_params|
        expect(rest_client_params[:params][:api_key]).to eq(Phaxio.api_key)
        expect(rest_client_params[:params][:api_secret]).to eq(Phaxio.api_secret)
      end
      client.request :get, 'faxes'
    end

    describe 'GET requests' do
      it 'sends the request to Phaxio' do
        endpoint = 'public/countries/'
        params = {page: 1, per_page: 10}
        request_url = URI.join(client::BASE_URL, endpoint).to_s
        expect(RestClient).to receive(:get) do |url, rest_client_params|
          expect(url).to eq(request_url)
          expect(rest_client_params[:params][:page]).to eq(params[:page])
          expect(rest_client_params[:params][:per_page]).to eq(params[:per_page])
        end
        client.request :get, endpoint, params
      end
    end
  end
end
