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

    def create_fax(options)
      Fax.build do |fax|
        fax.recipient = options.to_number
        fax.filename = options.filename
        fax.string_data = options.string_data
        fax.string_data_type = options.string_data_type
        fax.batch = options.batch
        fax.batch_delay = options.batch_delay
        fax.batch_collision_avoidance = options.batch_collision_avoidance
        fax.callback_url = options.callback_url
        fax.cancel_timeout = options.cancel_timeout
      end
    end

    def send_fax(path, fax)
      if path.nil?
        @path = "send"
      else
        @path = path
      end

      post(@path, options[:query].merge(to: fax.to_number, filename: fax.filename,
                                       string_data: fax.string_data, string_data_type: fax.string_data_type,
                                       batch: fax.batch, batch_delay: fax.batch_delay,
                                       batch_collision_avoidance: fax.batch_collision_avoidance,
                                       callback_url: fax.callback_url, cancel_timeout: fax.cancel_timeout,
                                       api_key: api_key, api_secret: api_secret))
    end

    def cancel_fax(path, options)
      if path.nil?
        @path = "/faxCancel"
      else
        @path = path
      end

      # add cancel logic here
    end

    def check_fax_status(path, fax_id)
      if path.nil?
        @path = "/faxStatus"
      else
        @path = path
      end

      if !fax_id 
        raise StandardError, "You must include a fax id"
      end

      get(@path, {id:fax_id})
    end


    def get_account_status(path)
      if path.nil?
        @path = "/accountStatus"
      else
        @path = path
      end

      status = get(@path, options[:query].merge(api_key: api_key, api_secret:api_secret))
      faxes_sent_this_month = status.faxes_sent_this_month
      faxes_sent_today = status.faxes_sent_today
      balance = status.balance
    end
  end
end
