TEST_API_KEY              = ENV.fetch 'TEST_PHAXIO_API_KEY',       'test-api-key'
TEST_API_SECRET           = ENV.fetch 'TEST_PHAXIO_API_SECRET',    'test-api-secret'
TEST_NUMBER               = ENV.fetch 'TEST_PHAXIO_NUMBER',        '+15558675309'
TEST_ATA_PROVISIONING_KEY = ENV.fetch 'TEST_ATA_PROVISIONING_KEY', 'test-ata-provisioning-key'
TEST_WEBHOOK_TOKEN        = 'test-webhook-token'

VCR.configure do |vcr|
  vcr.cassette_library_dir = File.join __dir__, 'cassettes'
  vcr.hook_into :faraday
  vcr.default_cassette_options = {record: :once, record_on_error: false}

  vcr.filter_sensitive_data('+15558675309') { TEST_NUMBER }
  vcr.filter_sensitive_data('<AUTH_HEADER>') { |interaction| interaction.request.headers['Authorization'].first }
  vcr.filter_sensitive_data('test-ata-provisioning-key') { TEST_ATA_PROVISIONING_KEY }

  vcr.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.before(:each) do
    Phaxio.api_key       = TEST_API_KEY
    Phaxio.api_secret    = TEST_API_SECRET
    Phaxio.webhook_token = TEST_WEBHOOK_TOKEN
  end
end

