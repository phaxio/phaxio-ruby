ENV['TEST_RECIPIENT_NUMBER'] ||= '+15558675309'

VCR.configure do |config|
  config.cassette_library_dir = File.expand_path File.join('..', 'vcr_cassettes'), __FILE__
  config.hook_into :faraday
  config.filter_sensitive_data('<API_KEY>') { Phaxio.api_key }
  config.filter_sensitive_data('<API_SECRET>') { Phaxio.api_secret }
  config.filter_sensitive_data('+15558675309') { ENV['TEST_RECIPIENT_NUMBER'] }
end
