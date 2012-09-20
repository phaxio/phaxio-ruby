$:<<(".")
require "test/unit"
require "fakeweb"
require "lib/phaxio"

FakeWeb.register_uri(:post, "https://api.phaxio.com/v1/send",
  :body         => File.open("test/support/responses/send_success.json").read,
  :content_type => "application/json")
