$:<<(".")
require "test/unit"
require "fakeweb"
require "lib/phaxio"

FakeWeb.register_uri(:post, "https://api.phaxio.com/v1",
  :body         => File.open("test/support/send.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:get, "https://api.phaxio.com/v1",
  :body         => File.open("test/support/fax_status.json").read,
  :content_type => "application/json")

FakeWeb.register_uri(:get, "https://api.phaxio.com/v1",
  :body         => File.open("test/support/account_status.json").read,
  :content_type => "application/json")
