require 'spec_helper'

RSpec.describe Webhook do
  describe 'validating a webhook signature' do
    let(:action) { Webhook.valid_signature? signature, url, params, files }
    let(:signature) { '64a735ef0c47a0ae671e381c046648f0966deb29' }
    let(:url) { 'example.com' }
    let(:params) { {test: true} }
    let(:files) { [] }

    it 'raises an error if Phaxio::Config.webhook_token is unset' do
      Phaxio.webhook_token = nil
      expect {
        action
      }.to raise_error(Phaxio::Error::PhaxioError, 'No webhook token has been set')
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

    context 'with files' do
      let(:signature) { '1d2426c242a8c5de7eb1d9b662b7fda1d0b6edab' }
      let(:params) { { test: true } }

      let(:file1) do
        tempfile = Tempfile.new
        tempfile.write("foo")
        tempfile
      end

      let(:file2) do
        tempfile = Tempfile.new
        tempfile.write("bar")
        tempfile
      end

      let(:files) do
        [
          { name: 'file', tempfile: file1 },
          { name: 'file', tempfile: file2  }
        ]
      end

      it 'returns true' do
        result = action
        expect(result).to eq(true)
      end

      it 'rewinds the files' do
        action
        expect(files.all? { |f| f[:tempfile].pos.zero? }).to eq(true)
      end
    end
  end
end
