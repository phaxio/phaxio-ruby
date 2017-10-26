require 'spec_helper'

RSpec.describe Phaxio do
  subject { Phaxio }

  it 'sets the api key' do
    subject.api_key = 'test-api-key'
    expect(subject.api_key).to eq('test-api-key')
  end

  it 'sets the api secret' do
    subject.api_secret = 'test-api-secret'
    expect(subject.api_secret).to eq('test-api-secret')
  end

  it 'sets the callback token' do
    subject.callback_token = 'test-callback-token'
    expect(subject.callback_token).to eq('test-callback-token')
  end
end
