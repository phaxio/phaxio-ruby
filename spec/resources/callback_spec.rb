require 'spec_helper'

RSpec.describe Callback do
  describe 'validating a callback signature' do
    let(:action) { Callback.valid_signature? signature, url, params, files }
    let(:signature) { '663099785e5eff09f0cd6f2bd5d78c852f3b670d' }
    let(:url) { 'example.com' }
    let(:params) { {test: true} }
    let(:files) { [] }

    it 'raises an error if Phaxio::Config.callback_token is unset' do
      Phaxio.callback_token = nil
      expect {
        action
      }.to raise_error(Phaxio::Error::PhaxioError, 'No callback token has been set')
    end

    context 'signature matches' do
      it 'returns true' do
        result = action
        expect(result).to eq(true)
      end
    end

    context 'signature does not match' do
      let(:signature) { 'wrong' }

      it 'returns false' do
        result = action
        expect(result).to eq(false)
      end
    end
  end
end