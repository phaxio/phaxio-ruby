$LOAD_PATH << '.'

require 'minitest/autorun'

require 'mocha/mini_test'
require 'fakeweb'
require 'lib/phaxio'

Phaxio.config do |config|
  config.api_key = '12345678910'
  config.api_secret = '10987654321'
  config.callback_token = '1234567890'
end

FakeWeb.register_uri(:post, "https://api.phaxio.com/v1/send",
  :body         => File.open("test/support/responses/send_success.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:post, "https://api.phaxio.com/v1/testReceive",
  :body         => File.open("test/support/responses/test_receive.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:post, "https://api.phaxio.com/v1/testReceive",
  :body         => File.open("test/support/responses/test_receive.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:post, "https://api.phaxio.com/v1/provisionNumber",
  :body         => File.open("test/support/responses/provision_number.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:post, "https://api.phaxio.com/v1/releaseNumber",
  :body         => File.open("test/support/responses/release_number.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:post, "https://api.phaxio.com/v1/numberList",
  :body         => File.open("test/support/responses/list_numbers.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:post, "https://api.phaxio.com/v1/faxFile",
  :body         => File.open("test/support/responses/test.pdf").read,
  :content_type => "application/pdf")

FakeWeb.register_uri(:post, "https://api.phaxio.com/v1/faxList",
  :body         => File.open("test/support/responses/list_faxes.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:post, "https://api.phaxio.com/v1/faxStatus",
  :body         => File.open("test/support/responses/fax_status_success.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:post, "https://api.phaxio.com/v1/faxCancel",
  :body         => File.open("test/support/responses/cancel_success.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:post, "https://api.phaxio.com/v1/accountStatus",
  :body         => File.open("test/support/responses/account_status.json").read,
  :content_type => "application/json")
