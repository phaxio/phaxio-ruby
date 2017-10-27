require 'spec_helper'

RSpec.describe Phaxio::Client do
  subject(:client) { Phaxio::Client }
  let(:test_connection) { instance_double Faraday::Connection }

  before do
    allow(client).to receive(:conn) { test_connection }
  end

  def test_response status_code, message: 'This is a test.'
    success = (200..299).include? status_code
    instance_double(
      Faraday::Response,
      status: status_code,
      success?: success,
      body: %Q({"success": #{success}, "message": "#{message}", "data": {"foo": "bar"}})
    )
  end

  describe 'making a request' do
    it 'sends the request to Phaxio' do
      endpoint = 'public/countries/'
      params = {page: 1, per_page: 10}
      expect(test_connection).to receive(:get) do |request_endpoint, request_params|
        expect(request_endpoint).to eq(endpoint)
        expect(request_params[:page]).to eq(params[:page])
        expect(request_params[:per_page]).to eq(params[:per_page])
        test_response 200
      end
      client.request :get, endpoint, params
    end

    it 'uses the configured API key and secret by default' do
      expect(test_connection).to receive(:get) do |_endpoint, request_params|
        expect(request_params[:api_key]).to eq(Phaxio.api_key)
        expect(request_params[:api_secret]).to eq(Phaxio.api_secret)
        test_response 200
      end
      client.request :get, 'test'
    end

    it 'uses the api key specified in the options hash' do
      custom_api_key = 'custom-api-key'
      custom_api_secret = 'custom-api-secret'
      expect(test_connection).to receive(:get) do |_endpoint, request_params|
        expect(request_params[:api_key]).to eq(custom_api_key)
        expect(request_params[:api_secret]).to eq(custom_api_secret)
        test_response 200
      end
      client.request :get, 'test', {}, {api_key: custom_api_key, api_secret: custom_api_secret}
    end

    it 'parses the response JSON and returns the data if the response indicates success' do
      expect(test_connection).to receive(:get) { test_response 200 }
      result = client.request :get, 'test'
      expect(result).to eq({'foo' => 'bar'})
    end

    it 'raises an authentication error if the response status is 401' do
      expect(test_connection).to receive(:get) { test_response 401 }
      expect {
        client.request :get, 'test'
      }.to raise_error(Phaxio::Error::AuthenticationError, '401: This is a test.')
    end

    it 'raises a not found error if the response status is 404' do
      expect(test_connection).to receive(:get) { test_response 404 }
      expect do
        client.request :get, 'test'
      end.to raise_error(Phaxio::Error::NotFoundError, '404: This is a test.')
    end

    it 'raises an invalid request error if the response status is 422' do
      expect(test_connection).to receive(:get) { test_response 422 }
      expect {
        client.request :get, 'test'
      }.to raise_error(Phaxio::Error::InvalidRequestError, '422: This is a test.')
    end

    it 'raises a rate limit error if the response status is 429' do
      expect(test_connection).to receive(:get) { test_response 429 }
      expect {
        client.request :get, 'test'
      }.to raise_error(Phaxio::Error::RateLimitExceededError, '429: This is a test.')
    end

    it 'raises a general error for if the response status is 5XX' do
      expect(test_connection).to receive(:get) { test_response 500 }
      expect {
        client.request :get, 'test'
      }.to raise_error(Phaxio::Error::GeneralError, '500: This is a test.')
    end

    it 'raises a general error if the response status is some other value' do
      expect(test_connection).to receive(:get) { test_response 418 }
      expect {
        client.request :get, 'test'
      }.to raise_error(Phaxio::Error::GeneralError, '418: This is a test.')
    end

    it 'raises an API connection error if a networking issue occurs' do
      expect(test_connection).to receive(:get) { raise Faraday::ConnectionFailed, 'This is a test.' }
      expect {
        client.request :get, 'test'
      }.to raise_error(Phaxio::Error::ApiConnectionError, 'Error communicating with Phaxio: This is a test.')
    end

    it 'allows unknown errors to bubble up' do
      expect(test_connection).to receive(:get) { raise RuntimeError, 'This is a test.' }
      expect {
        client.request :get, 'test'
      }.to raise_error(RuntimeError, 'This is a test.')
    end

    it 'raises a general error if the status indicates success but the body indicates failure' do
      expect(test_connection).to receive(:get) do
        instance_double(
          Faraday::Response,
          status: 200,
          success?: true,
          body: '{"success": false, "message": "Something bad happened.", "data": {"foo": "bar"}}'
        )
      end
      expect {
        client.request :get, 'test'
      }.to raise_error(Phaxio::Error::GeneralError, "Something bad happened.")
    end
  end
end
