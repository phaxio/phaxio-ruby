require "phaxio/version"
require "phaxio/config"
require "phaxio/client"

module Phaxio
  include  HTTMultiParty

  base_uri 'http://api.phaxio.com/v1'

  private

    def config
      Config.configure do |client|
        client.api_key = ""
        client.api_secret = ""
      end
    end
end
