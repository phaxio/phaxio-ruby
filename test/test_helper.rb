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

FakeWeb.allow_net_connect = false

FakeWeb.register_uri(:post, "https://12345678910:10987654321@api.phaxio.com/v2/faxes",
  :body         => File.open("test/support/responses/send_success.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:post, "https://12345678910:10987654321@api.phaxio.com/v2/phone_numbers",
  :body         => File.open("test/support/responses/provision_number.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:delete, "https://12345678910:10987654321@api.phaxio.com/v2/phone_numbers/8021112222",
  :body         => File.open("test/support/responses/release_number.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:get, "https://12345678910:10987654321@api.phaxio.com/v2/phone_numbers?country_code=1&area_code=802",
  :body         => File.open("test/support/responses/list_numbers.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:get, "https://12345678910:10987654321@api.phaxio.com/v2/faxes/1234/file",
  :body         => File.open("test/support/responses/test.pdf").read,
  :content_type => "application/pdf")

FakeWeb.register_uri(:get, "https://12345678910:10987654321@api.phaxio.com/v2/faxes?created_after=1293861600&created_before=1294034400",
  :body         => File.open("test/support/responses/list_faxes.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:get, "https://12345678910:10987654321@api.phaxio.com/v2/faxes/123456",
  :body         => File.open("test/support/responses/fax_status_success.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:post, "https://12345678910:10987654321@api.phaxio.com/v2/faxes/123456/cancel",
  :body         => File.open("test/support/responses/cancel_success.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:get, "https://12345678910:10987654321@api.phaxio.com/v2/account/status",
  :body         => File.open("test/support/responses/account_status.json").read,
  :content_type => "application/json")
