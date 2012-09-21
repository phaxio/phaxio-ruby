module Phaxio
  module Config
    attr_accessor :api_key, :api_secret
  end
  class Client
    include  HTTParty
    base_uri 'https://api.phaxio.com/v1'

    attr_accessor :faxes_sent_this_month, :faxes_sent_today, :balance

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

    def cancel_fax(options)
      # @path = "/faxCancel"

      # add cancel logic here
    end

    def check_fax_status(fax_id)
      if !fax_id 
        raise StandardError, "You must include a fax id"
      end

      get("/faxStatus", {id:fax_id})
    end

    def get_account_status
      status = get("/accountStatus", options[:query].merge(api_key: api_key, api_secret:api_secret))
      faxes_sent_this_month = status.faxes_sent_this_month
      faxes_sent_today = status.faxes_sent_today
      balance = status.balance
    end
  end

  def self.client
    @client ||= Client.new
  end

end
