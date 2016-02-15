module Phaxio
  include  HTTMultiParty
  base_uri 'https://api.phaxio.com/v1'

  module Config
    attr_accessor :api_key, :api_secret, :callback_token
  end

  module Client
    DIGEST = OpenSSL::Digest.new('sha1')

    class InvalidCallbackSignature < StandardError; end

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
    #   Phaxio.send_fax(to: "0123456789", filename: "test.pdf")
    #
    # Returns a HTTParty::Response object containing a success bool,
    # a String message, and an in faxID.
    def send_fax(options)
      send_post("/send", options)
    end

    # Public: Resend a fax.
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           :id - The int id of the fax you want to resend (required).
    #
    # Examples
    #
    #   Phaxio.resend_fax(id: "123456")
    #
    # Returns a HTTParty::Response object containing a success bool,
    # a message string, and data containing the fax ID int.
    def resend_fax(options)
      send_post("/resendFax", options)
    end

    # Public: Test receiving a fax.
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           from_number - The Phone Number of the simulated sender
    #                         (optional).
    #           to_number   - The Phone Number receiving the fax (optional).
    #           filename    - A String containing the name of the PDF that has
    #                         a PhaxCode and is the file you want to simulate
    #                         sending (required).
    #
    # Examples
    #
    #   Phaxio.test_receive(filename: "test_file.pdf")
    #
    # Returns a HTTParty::Response object containing a success bool
    # and a String message.
    def test_receive(options)
      send_post("/testReceive", options)
    end

    # Public: Provision a phone number that you can use to receive faxes in
    #         your Phaxio account.
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           area_code    - The integer area code of the number you'd like
    #                          to provision (required).
    #           callback_url - A callback URL that Phaxio will post to when a
    #                          fax is received by this number. This will
    #                          override the global receive callback URL, if you
    #                          have one set (optional).
    #
    # Examples
    #
    #   Phaxio.provision_number(area_code: 802)
    #
    # Returns a HTTParty::Response object containing a success bool, a string
    # message, and data containing the phone number, city, state, cost,
    # last_billed_at, and the date the number was provisioned at.
    def provision_number(options)
      send_post("/provisionNumber", options)
    end

    # Public: Release a phone number that you no longer need. Once a phone
    #         number is released you will no longer be charged for it.
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           number - The String of the phone number you want to release
    #                    (required).
    #
    # Examples
    #
    #   Phaxio.release_number(number: "8021112222")
    #
    # Returns a HTTParty::Response object containing a success bool and a
    # string message.
    def release_number(options)
      send_post("/releaseNumber", options)
    end

    # Public: Get a detailed list of the phone numbers you current own on
    #         Phaxio.
    #
    # options - The Hash options used to refne th selection (default: {}):
    #           area_code - An integer area code you'd like to filter by
    #                       (optional).
    #           number    - A String phone number you'd like to retrieve
    #                       (optional).
    #
    # Examples
    #
    #   Phaxio.list_numbers # list all the numbers you own
    #
    #   Phaxio.list_numbers(area_code: 802) # list all numbers in the 802 area
    #
    #   Phaxio.list_numbers(number: "8021112222") # show specific number detail
    #
    # Returns a HTTParty::Reponse object containing a success bool, a message,
    # and the data attributes containing the queried phone number(s) details.
    def list_numbers(options = {})
      send_post("/numberList", options)
    end

    # Public: Get an image thumbnail or PDF file for a fax. For images to work
    #         file storage must not be disabled with Phaxio.
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           id   - The integer fax id of the fax you wish to retreive
    #                  (required).
    #           type - An enum for the type return, defaults to 'p' (optional):
    #                  s - Small JPG format thumbnail of the fax, 129 x 167 px.
    #                  l - Large JPG format thumbnail of the fax, 300 x 388 px.
    #                  p - PDF version of the fax (default).
    #
    # Examples
    #
    #   Phaxio.get_fax_file(id: 1234, type: p)
    #   Phaxio.get_fax_file(id: 3254, type: l)
    #
    # Returns the fax as the type specified in the call, defaults to PDF.
    def get_fax_file(options)
      send_post("/faxFile", options)
    end

    # Public: List faxes within the specified time range.
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           start - The Unix Timestamp for the beginning of the range
    #                   (required).
    #           end   - The Unix Timestamp for the end of the range (required).
    #
    # Examples
    #
    #   Phaxio.list_faxes(start: 1293861600, end: 1294034400)
    #
    # Returns a HTTParty::Response object containing a success bool, a string
    # message, paging information, and the fax data.
    def list_faxes(options)
      send_post("/faxList", options)
    end

    # Public: Get the status of a specific fax.
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           id - The int id of the fax you want to get the status of
    #                (required).
    #
    # Examples
    #
    #   Phaxio.get_fax_status(id: "123456")
    #
    # Returns a HTTParty::Response object containing a success bool,
    # a String message, and the data of the fax.
    def get_fax_status(options)
      if options[:id].nil?
        raise StandardError, "You must include a fax id."
      end

      send_post("/faxStatus", options)
    end

    # Public: Cancel a specific fax.
    #
    # options - The Hash options used to refine the selection (defaults: {}):
    #           id - The int id of the fax you want to cancel (required).
    #
    # Examples
    #
    #   Phaxio.cancel_fax(id: "123456")
    #
    # Returns a HTTParty::Response object containing a success bool
    # and a String message.
    def cancel_fax(options)
      send_post("/faxCancel", options)
    end

    # Public: Delete a specific fax.
    #
    # options - The hash options used to refine the selection (defaults: {}):
    #           :id         - The int ID of the fax you want to cancel
    #                         (required).
    #           :files_only - The bool used to determine whether only the files
    #                         are deleted. If not specified, default is false
    #                         (optional).
    #
    # Examples
    #
    #   Phaxio.delete_fax(id: 1234, files_only: true)
    #
    # Returns a HTTParty::Response object with success bool and message string.
    def delete_fax(options)
      send_post("/deleteFax", options)
    end

    # Public: Get the status of Client's account.
    #
    # Examples
    #
    #   Phaxio.get_account_status
    #
    # Returns a HTTParty::Response object with success, message, and data
    # (containing faxes_sent_this_month, faxes_sent_today, and balance).
    def get_account_status
      send_post("/accountStatus", {})
    end

    def send_post(path, options)
      post(path, query: options.merge!({api_key: api_key, api_secret: api_secret}))
    end

    # Public: Check the signature of the signed request.
    #
    # options - Type: hash. Information needed to authenticate the callback.
    #   :url       - Type: string. The full URL that was called by Phaxio,
    #                including the query. (required)
    #   :params    - Type: hash. The POSTed form data (required)
    #   :files     - Type: array. Submitted files (required - "received" fax
    #                callback only)
    #   :signature - Type: string. The X-Phaxio-Signature HTTP header value
    #
    # Returns true if the signature matches the signed request, otherwise false
    def valid_callback_signature?(**options)
      callback_signature = options.fetch(:signature)
      check_signature = generate_check_signature(**options)
      callback_signature == check_signature
    end

    # Public: Generate a signature using the request data and callback token
    #
    # options - Type: hash. Information needed to authenticate the callback.
    #   :url       - Type: string. The full URL that was called by Phaxio,
    #                including the query. (required)
    #   :params    - Type: hash. The POSTed form data (required)
    #   :files     - Type: array. Submitted files (required - "received" fax
    #                callback only)
    #
    # Retuns a signature based on the request data and configured callback
    # token, which can then be compared with the request signature.
    def generate_check_signature(**options)
      url = options.fetch(:url)
      params_string = generate_params_string(options.fetch(:params))
      file_string = generate_files_string(options.fetch(:files, []))
      callback_data = "#{url}#{params_string}#{file_string}"
      OpenSSL::HMAC.hexdigest(DIGEST, callback_token, callback_data)
    end

    private

    def generate_params_string(params)
      cleaned_params = sort_params(strip_params(params))
      params_strings = cleaned_params.map { |key, value| "#{key}#{value}" }
      params_strings.join
    end

    def generate_files_string(files)
      return if files.nil?
      files_array = files_to_array(files)
      sorted_files = sort_files(files_array)
      files_strings = sorted_files.map { |file| generate_file_string(file) }
      files_strings.join
    end

    def strip_params(params)
      params.reject { |key, _value| key.to_s == 'filename' }
    end

    def sort_params(params)
      params.sort_by { |key, _value| key }
    end

    def files_to_array(files)
      files.is_a?(Array) ? files : [files]
    end

    def sort_files(files)
      files.sort_by { |file| file[:name] }
    end

    def generate_file_string(file)
      file[:name] + DIGEST.hexdigest(file[:tempfile].read)
    end
  end

  # Public: Configure Phaxio with your api_key, api_secret, and the callback
  #         token provided in your Phaxio account (to verify that requests are
  #         coming from Phaxio).
  #
  # Examples
  #
  #   Phaxio.config do |config|
  #      config.api_key = '12345678910'
  #      config.api_secret = '10987654321'
  #      config.callback_token = '32935829'
  #    end
  #
  # Returns nothing.
  def self.config
    yield(self)
  end

  extend Client
  extend Config
end
