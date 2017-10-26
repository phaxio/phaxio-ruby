require 'spec_helper'

RSpec.describe Phaxio::Client do
  subject(:client) { Phaxio::Client }

  let(:test_response) do
    instance_double(
      RestClient::Response,
      code: 200,
      body: "{\"success\": true, \"message\": \"This is a test response.\", \"data\": {\"foo\": \"bar\"}}"
    )
  end

  describe 'making a request' do
    it 'uses the configured API key and secret by default' do
      expect(RestClient).to receive(:get) do |_url, rest_client_params|
        expect(rest_client_params[:params][:api_key]).to eq(Phaxio.api_key)
        expect(rest_client_params[:params][:api_secret]).to eq(Phaxio.api_secret)
        test_response
      end
      client.request :get, 'faxes'
    end

    it 'uses the api key specified in the options hash' do
      custom_api_key = 'custom-api-key'
      custom_api_secret = 'custom-api-secret'
      expect(RestClient).to receive(:get) do |_url, rest_client_params|
        expect(rest_client_params[:params][:api_key]).to eq(custom_api_key)
        expect(rest_client_params[:params][:api_secret]).to eq(custom_api_secret)
        test_response
      end
      client.request :get, 'faxes', {}, {api_key: custom_api_key, api_secret: custom_api_secret}
    end

    it 'parses the response JSON and returns the data if the response indicates success' do
      expect(RestClient).to receive(:get) { test_response }
      result = client.request :get, 'faxes'
      expect(result).to eq({'foo' => 'bar'})
    end

    xit 'raises a rate limit error if the response status is 429'

    xit 'raises an invalid request error if the response status is 422'

    xit 'raises an authentication error if the response status is 401'

    xit 'raises a not found error if the response status is 404'

    xit 'raises an API connection error if a networking issue occurs'

    xit 'raises a general error for if the response status is 5XX'

    xit 'raises a general error if the response status is some other value'

    xit 'raises a general error if the response indicates failure'

    describe 'GET requests' do
      it 'sends the request to Phaxio' do
        endpoint = 'public/countries/'
        params = {page: 1, per_page: 10}
        request_url = URI.join(client::BASE_URL, endpoint).to_s
        expect(RestClient).to receive(:get) do |url, rest_client_params|
          expect(url).to eq(request_url)
          expect(rest_client_params[:params][:page]).to eq(params[:page])
          expect(rest_client_params[:params][:per_page]).to eq(params[:per_page])
          test_response
        end
        client.request :get, endpoint, params
      end
    end
  end
end
