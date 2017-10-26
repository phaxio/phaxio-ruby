RSpec.configure do |config|
  config.before(:each) do
    Phaxio.api_key = ENV['PHAXIO_API_KEY'] || 'test-api-key'
    Phaxio.api_secret = ENV['PHAXIO_API_SECRET'] || 'test-api-secret'
  end
end
