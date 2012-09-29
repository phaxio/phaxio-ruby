$:<<(".")
require "test/unit"
require "fakeweb"
require "lib/phaxio"

FakeWeb.register_uri(:post, "https://api.phaxio.com/v1/send",
  :body         => File.open("test/support/responses/send_success.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:post, "https://api.phaxio.com/v1/testReceive",
  :body         => File.open("test/support/responses/test_receive.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:post, "https://api.phaxio.com/v1/faxCancel",
  :body         => File.open("test/support/responses/cancel_success.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:post, "https://api.phaxio.com/v1/accountStatus",
  :body         => File.open("test/support/responses/account_status.json").read,
  :content_type => "application/json")
