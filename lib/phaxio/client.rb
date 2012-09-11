module Phaxio
  class Client
    attr_accessor :api_key, :api_secret

    def create_fax(options)
      Fax.build do |fax|
        fax.recipient = options.recipient
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
      post(path, options[:query].merge(to: fax.recipient, filename: fax.filename,
                                       string_data: fax.string_data, string_data_type: fax.string_data_type,
                                       batch: fax.batch, batch_delay: fax.batch_delay,
                                       batch_collision_avoidance: fax.batch_collision_avoidance,
                                       callback_url: fax.callback_url, cancel_timeout: fax.cancel_timeout,
                                       api_key: self.api_key, api_secret: self.api_secret))
    end
  end
end
