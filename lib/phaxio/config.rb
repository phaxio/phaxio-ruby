module Phaxio
  class Config
    class << self
      attr_accessor :api_key, :api_secret, :callback_token
    end
  end
end
