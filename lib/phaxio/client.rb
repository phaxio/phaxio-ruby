module Phaxio
  module Config
    attr_accessor :api_key, :api_secret
  end

  class Client
    include  HTTParty
    base_uri 'https://api.phaxio.com/v1'

    # Public: Initialize a new Client.
    #
    # Returns nothing.
    def initialize
      extend(Config)
    end

    # Public: Configure a Client.
    #
    # Returns the Client.
    def config
      if block_given?
        yield(self)
      end

      self
    end

    # Public: Send a fax.
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           :to                        - The Phone Number (i.e. [country
    #                                        code][number] or just a 10 digit
    #                                        number in the US or Canada). Put
    #                                        square brackets after parameter
    #                                        name to send to multiple
    #                                        recipients (e.g. to[]) (required).
    #           :filename                  - The Binary Stream name of the file
    #                                        you want to fax. This is optional
    #                                        if you specify string_data. Must
    #                                        have file name in the filename
    #                                        field of the body-part header. Put
    #                                        square brackets after parameter
    #                                        name to send multiple files (e.g.
    #                                        filename[]) (required).
    #           :string_data               - A String of html, plain text, or a
    #                                        URL. If additional files are
    #                                        specified as well, this data will
    #                                        be included first in the fax
    #                                        (optional).
    #           :string_data_type          - An enum of the type of the string
    #                                        data that can be 'html', 'url', or
    #                                        'text'. If not specified, default
    #                                        is 'text'. See string data
    #                                        rendering for more info (optional).
    #           :batch                     - The bool for running in batching
    #                                        mode. If present and true, fax will
    #                                        be sent in batching mode. Requires
    #                                        batch_delay to be specified
    #                                        (optional).
    #           :batch_delay               - The int the of amount of time, in
    #                                        seconds, before the batch is fired.
    #                                        Must be specified if batch=true.
    #                                        Maximum delay is 3600 (1 hour)
    #                                        (optional).
    #           :batch_collision_avoidance - The bool for collision avoidance
    #                                        with batches. If true when
    #                                        batch=true, fax will be blocked
    #                                        until the receiving machine is no
    #                                        longer busy (optional).
    #           :callback_url              - The String url for the callback.
    #                                        Overrides the globally set one
    #                                        (optional).
    #           :cancel_timeout            - An int of the number of minutes
    #                                        after which the fax will be
    #                                        canceled if it hasn't yet
    #                                        completed. Must be between 1 and 60
    #                                        (optional).
    #
    # Examples
    #
    # Returns the json data from the send post.
    def send_fax(options)
      options.merge!({api_key: api_key, api_secret: api_secret})
      self.class.post("/send", options)
    end

    # Public: Test receiving a fax.
    def test_receive(options)
      options.merge!({api_key: api_key, api_secret: api_secret})
      self.class.post("/testReceive", options)
    end

    # Public: Get the status of a specific fax.
    def get_fax_status(options)
      if options[:id].nil?
        raise StandardError, "You must include a fax id."
      end

      self.class.post("/faxStatus", options)
    end

    # Public: Cancel a specific fax.
    def cancel_fax(options)
      options.merge!({api_key: api_key, api_secret: api_secret})
      self.class.post("/faxCancel", options)
    end

    # Public: Get the status of Client's account.
    def get_account_status
      status = self.class.post("/accountStatus", { api_key: api_key, api_secret:api_secret })
    end
  end

  def self.client
    @client ||= Client.new
  end

end
