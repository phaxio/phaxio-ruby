module Phaxio
  class Config
    def self.configure(&block)
      Client.new.tap do |client|
        yield client
      end
    end
  end
end
