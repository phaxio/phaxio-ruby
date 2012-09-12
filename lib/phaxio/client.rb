module Phaxio
  class Client
    include  HTTParty
    base_uri 'http://api.phaxio.com/v1'

    attr_accessor :api_key, :api_secret, :faxes_sent_this_month,
                  :faxes_sent_today, :balance

    def initialize(api_key, api_secret)
      self.api_key = api_key
      self.api_secret = api_secret
    end

    def send_fax(fax={})
      post("send", options[:query].merge(to: fax.to_number, filename: fax.filename,
                                       string_data: fax.string_data, string_data_type: fax.string_data_type,
                                       batch: fax.batch, batch_delay: fax.batch_delay,
                                       batch_collision_avoidance: fax.batch_collision_avoidance,
                                       callback_url: fax.callback_url, cancel_timeout: fax.cancel_timeout,
                                       api_key: api_key, api_secret: api_secret))
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
end
