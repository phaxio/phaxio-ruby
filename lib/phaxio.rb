require "phaxio/version"
require "phaxio/config"
require "phaxio/client"

module Phaxio
  def config
    Config.configure do |client|
      client.api_key = "abc123"
      client.api_secret = "abc123"
    end
  end
end
