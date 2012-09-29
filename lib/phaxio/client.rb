module Phaxio
  module Config
    attr_accessor :api_key, :api_secret
  end
  class Client
    include  HTTParty
    base_uri 'https://api.phaxio.com/v1'

    def initialize
      extend(Config)
    end

    def config
      if block_given?
        yield(self)
      end

      self
    end

    def send_fax(options)
      options.merge!({api_key: api_key, api_secret: api_secret})
      self.class.post("/send", options)
    end

    def test_receive(options)
      options.merge!({api_key: api_key, api_secret: api_secret})
      self.class.post("/testReceive", options)
    end

    def check_fax_status(fax_id)
      if !fax_id 
        raise StandardError, "You must include a fax id"
      end

      get("/faxStatus", {id:fax_id})
    end

    def cancel_fax(options)
      options.merge!({api_key: api_key, api_secret: api_secret})
      self.class.post("/faxCancel", options)
    end

    def get_account_status
      status = self.class.post("/accountStatus", { api_key: api_key, api_secret:api_secret })
    end
  end

  def self.client
    @client ||= Client.new
  end

end
