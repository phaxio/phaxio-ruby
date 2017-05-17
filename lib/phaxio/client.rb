module Phaxio
  include  HTTMultiParty
  base_uri 'https://api.phaxio.com/v2'

  module Config
    attr_accessor :api_key, :api_secret, :callback_token
  end

  module Client
    DIGEST = OpenSSL::Digest.new('sha1')

    # Public: Send a fax.
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           :to                        - The Phone Number (i.e. [country
    #                                        code][number] or just a 10 digit
    #                                        number in the US or Canada). Put
    #                                        square brackets after parameter
    #                                        name to send to multiple
    #                                        recipients (e.g. to[]) (required).
    #           :file                      - The file you wish to fax. A least
    #                                        one file or content_url parameter
    #                                        is required. Must have file name
    #                                        in the file field of the body-part
    #                                        header. Put square brackets after
    #                                        parameter name to send multiple
    #                                        files (e.g. file[])
    #           :content_url               - A URL to be rendered and sent as
    #                                        the fax content. At least one file
    #                                        or content_url parameter is
    #                                        required. Put square brackets
    #                                        after parameter name to include
    #                                        content from multiple URLs (e.g.
    #                                        content_url[]). If the file param
    #                                        is specified as well, content from
    #                                        URLs will be rendered before
    #                                        content from files (optional).
    #           :header_text               - Text that will be displayed at the
    #                                        top of each page of the fax. 50
    #                                        characters maximum. Default header
    #                                        text is "-". Note that the header
    #                                        is not applied until the fax is
    #                                        transmitted, so it will not appear
    #                                        on fax PDFs or thumbnails
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
    #           :tag[TAG_NAME]             - A tag that contains metadata
    #                                        relevant to your application.
    #                                        (e.g. You may wish to tag a fax
    #                                        with an order id in your
    #                                        application. You could pass Phaxio
    #                                        the following parameter:
    #                                        tag[order_id]=1234). You may
    #                                        specify up to 10 tags (optional).
    #           :caller_id                 - A Phaxio phone number you would
    #                                        like to use for the caller id
    #                                        (optional).
    #           :test_fail                 - When using a test API key, this
    #                                        will simulate a sending failure at
    #                                        Phaxio. The contents of this
    #                                        parameter should be one of the
    #                                        Phaxio error types which will
    #                                        dictate how the fax will "fail"
    #                                        (optional).
    #
    # Examples
    #
    #   Phaxio.send_fax(to: "0123456789", file: "test.pdf")
    #
    # Returns a HTTParty::Response object containing a success bool,
    # a String message, and an in faxID.
    def send_fax(options)
      send_post("/faxes", options)
    end

    # Public: Resend a fax.
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           :id           - The int id of the fax you want to resend
    #                           (required).
    #           :callback_url - This parameter may be used to set a different
    #                           callback URL for the new fax (optional).
    #
    # Examples
    #
    #   Phaxio.resend_fax(id: "123456")
    #
    # Returns a HTTParty::Response object containing a success bool,
    # a message string, and data containing the fax ID int.
    def resend_fax(options)
      raise ArgumentError, "You must include a fax id." if options[:id].nil?
      id = options.delete(:id)
      send_post("/faxes/#{id}/resend", options)
    end

    # Public: Test receiving a fax.
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           direction   - Set to "received" to receive test fax
    #                         (required).
    #           file        - A PDF file to simulate receiving (required).
    #           from_number - The Phone Number of the simulated sender
    #                         (optional).
    #           to_number   - The Phone Number receiving the fax (optional).
    #
    # Examples
    #
    #   Phaxio.test_receive(direction: "received", file: "test_file.pdf")
    #
    # Returns a HTTParty::Response object containing a success bool
    # and a String message.
    def test_receive(options)
      if options[:direction].nil?
        raise ArgumentError, "You must include a direction."
      end
      send_post("/faxes", options)
    end

    # Public: Provision a phone number that you can use to receive faxes in
    #         your Phaxio account.
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           country_code - The country code (E.164) of the number you'd
    #                          like to provision (required).
    #           area_code    - The integer area code of the number you'd like
    #                          to provision (required).
    #           callback_url - A callback URL that Phaxio will post to when a
    #                          fax is received by this number. This will
    #                          override the global receive callback URL, if you
    #                          have one set (optional).
    #
    # Examples
    #
    #   Phaxio.provision_number(country_code: 1, area_code: 802)
    #
    # Returns a HTTParty::Response object containing a success bool, a string
    # message, and data containing the phone number, city, state, cost,
    # last_billed_at, and the date the number was provisioned at.
    def provision_number(options)
      send_post("/phone_numbers", options)
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
      if options[:number].nil?
        raise ArgumentError, "You must include a fax number."
      end
      send_delete("/phone_numbers/#{options[:number]}")
    end

    # Public: Get a detailed list of the phone numbers you current own on
    #         Phaxio.
    #
    # options - The Hash options used to refne th selection (default: {}):
    #           area_code    - An integer area code you'd like to filter by
    #                          (optional).
    #           country_code - A country code (E.164) you'd like to filter by.
    #                          (optional).
    #
    # Examples
    #
    #   Phaxio.list_numbers # list all the numbers you own
    #
    #   Phaxio.list_numbers(country_code: 1, area_code: 802) # list all numbers in the 802 area
    #
    # Returns a HTTParty::Reponse object containing a success bool, a message,
    # and the data attributes containing the queried phone number(s) details.
    def list_numbers(options = {})
      send_get("/phone_numbers", options)
    end

    # Public: Get an image thumbnail or PDF file for a fax. For images to work
    #         file storage must not be disabled with Phaxio.
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           id        - The integer fax id of the fax you wish to retreive
    #                       (required).
    #           thumbnail - An enum for the type return, defaults to 'p' (optional):
    #                       s - Small JPG format thumbnail of the fax, 129 x 167 px.
    #                       l - Large JPG format thumbnail of the fax, 300 x 388 px.
    #
    # Examples
    #
    #   Phaxio.get_fax_file(id: 1234)
    #   Phaxio.get_fax_file(id: 3254, thumbnail: 'l')
    #
    # Returns the fax as the type specified in the call, defaults to PDF.
    def get_fax_file(options)
      raise ArgumentError, "You must include a fax id." if options[:id].nil?
      id = options.delete(:id)
      send_get("/faxes/#{id}/file", options)
    end

    # Public: List faxes within the specified time range.
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           created_before - The end of the range. Must be in RFC 3339
    #                            format, except that the timezone may be
    #                            obmitted (e.g. '`2016-05-31T23:59:59`').
    #                            Defaults to now (optional).
    #           created_after  - The beginning of the range. Must be in RFC
    #                            3339 format, except that the timezone may be
    #                            obmitted (e.g. '`2016-05-01T00:00:00`').
    #                            Defaults to one week ago (optional).
    #           direction      - Either '`sent`' or '`received`'. Limits
    #                            results to faxes with the specified
    #                            direction (optional).
    #           status         - Limits results to faxes with the specified
    #                             status (optional).
    #           phone_number   - A phone number in E.164 format that you want
    #                            to use to filter results. The phone number
    #                            must be an exact match, not a number fragment
    #                            (optional).
    #           tag[TAG_NAME]  - A tag name and value that you want to use to
    #                            filter results. (e.g. You could pass a
    #                            parameter called `tag[userId]` with value
    #                            `123` to retrieve faxes for a user in your
    #                            application that has ID 123.) (optional).
    #
    # Examples
    #
    #   Phaxio.list_faxes(created_before: 1293861600, created_after: 1294034400)
    #
    # Returns a HTTParty::Response object containing a success bool, a string
    # message, paging information, and the fax data.
    def list_faxes(options)
      send_get("/faxes", options)
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
      raise ArgumentError, "You must include a fax id." if options[:id].nil?
      id = options.delete(:id)

      send_get("/faxes/#{id}", options)
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
      raise ArgumentError, "You must include a fax id." if options[:id].nil?
      id = options.delete(:id)
      send_post("/faxes/#{id}/cancel", options)
    end

    # Public: Delete a specific fax.
    #
    # options - The hash options used to refine the selection (defaults: {}):
    #           :id         - The int ID of the fax you want to cancel
    #                         (required).
    #
    # Examples
    #
    #   Phaxio.delete_fax(id: 1234, files_only: true)
    #
    # Returns a HTTParty::Response object with success bool and message string.
    def delete_fax(options)
      raise ArgumentError, "You must include a fax id." if options[:id].nil?
      id = options.delete(:id)
      send_delete("/faxes/#{id}", options)
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
      send_get("/account/status")
    end

    # Public: Create a custom PhaxCode.
    #
    # options - Type: hash. Options used to refine the action (default: {}):
    #           metadata - Type: string. Custom metadata to be associated with
    #                      this barcode. If not present, the basic PhaxCode for
    #                      your account will be used. (optional)
    #
    # Example:
    #   Phaxio.create_phaxcode(metadata: "sale_id=44")
    #
    # Response: If the redirect parameter is not provided, a JSON object with
    #           success, message, and data attributes is returned. The data
    #           attribute contains a url where the PhaxCode barcode image can be
    #           accessed. Otherwise, the image data is dumped in the response.
    def create_phaxcode(options = {})
      send_post('/phax_codes', options)
    end

    # Public: Get a list of supported countries for sending faxes
    #
    # Note: This method doesn't require API keys and is included for the sake of
    #       completion.
    #
    # Example:
    #   Phaxio.supported_countries
    #
    # Response: A JSON object with success, message, and data attributes. The
    #           data attribute contains a hash, where the key contains the name
    #           of the country, and the value is a hash of attributes for the
    #           country (currently only pricing information).
    #
    # Example Response:
    #   {
    #     "success": true,
    #     "message": "Data contains supported countries.",
    #     "data": [
    #       {
    #         "name": "United States",
    #         "alpha2": "US",
    #         "country_code": 1,
    #         "price_per_page": 7,
    #         "send_support": "full",
    #         "receive_support": "full"
    #       },
    #       {
    #         "name": "Canada",
    #         "alpha2": "CA",
    #         "country_code": 1,
    #         "price_per_page": 7,
    #         "send_support": "full",
    #         "receive_support": "full"
    #       },
    #       ...
    #     ],
    #     "paging": {
    #       "total": 47,
    #       "per_page": 3,
    #       "page": 1
    #     }
    #   }
    def supported_countries(options = {})
      get('/public/countries', query: options)
    end

    # Public: List area codes available for purchasing numbers
    #
    # Note: This method doesn't require API keys and is included for the sake of
    #       completion.
    #
    # options - Type: hash. Options used to refine the query (default: {}):
    #           toll_free    - Type: boolean. Will only return toll free area
    #                          codes. (optional)
    #           country_code - Type: integer. A country code (E.164) you'd like
    #                          to filter by. (optional)
    #           country      - Type: string. A two character country
    #                          abbreviation (ISO 3166; e.g. `US` or `CA`) you'd
    #                          like to filter by. (optional)
    #           state        - Type: string. A two character state or province
    #                          abbreviation (e.g. IL or YT). Will only return
    #                          area codes for this state. (optional)
    #
    # Response: A JSON object with success, message, and data attributes. The
    #           data attribute contains a map of area codes to city and state.
    #
    # Example response:
    #   {
    #     "success": true,
    #     "message": "295 area codes available.",
    #     "data": [
    #       {
    #         "country_code": 1,
    #         "area_code": 201,
    #         "city": "Bayonne, Jersey City, Union City",
    #         "state": "New Jersey",
    #         "country": "United States",
    #         "toll_free": false
    #       },
    #       {
    #         "country_code": 1,
    #         "area_code": 202,
    #         "city": "Washington",
    #         "state": "District of Columbia",
    #         "country": "United States",
    #         "toll_free": false
    #       },
    #       ... a lot more area codes here...
    #     ],
    #     "paging": {
    #       "total": 270,
    #       "per_page": 3,
    #       "page": 1
    #     }
    #   }
    def area_codes(options = {})
      get('/public/area_codes', query: options)
    end

    def send_get(path, options = {})
      send_authenticated_request(:get, path, options)
    end

    def send_post(path, options = {})
      send_authenticated_request(:post, path, options)
    end

    def send_delete(path, options = {})
      send_authenticated_request(:delete, path, options)
    end

    def send_authenticated_request(method, path, options = {})
      auth = { username: api_key, password: api_secret }
      send(method, path, query: options, basic_auth: auth)
    end

    # Public: Check the signature of the signed request.
    #
    # signature - Type: string. The X-Phaxio-Signature HTTP header value.
    # url       - Type: string. The full URL that was called by Phaxio,
    #                including the query. (required)
    # params    - Type: hash. The POSTed form data (required)
    # files     - Type: array. Submitted files (required - "received" fax
    #                callback only)
    #
    # Returns true if the signature matches the signed request, otherwise false
    def valid_callback_signature?(signature, url, params, files = [])
      check_signature = generate_check_signature(url, params, files)
      check_signature == signature
    end

    # Public: Generate a signature using the request data and callback token
    #
    # url       - Type: string. The full URL that was called by Phaxio,
    #                including the query. (required)
    # params    - Type: hash. The POSTed form data (required)
    # files     - Type: array. Submitted files (required - "received" fax
    #                callback only)
    #
    # Retuns a signature based on the request data and configured callback
    # token, which can then be compared with the request signature.
    def generate_check_signature(url, params, files = [])
      params_string = generate_params_string(params)
      file_string = generate_files_string(files)
      callback_data = "#{url}#{params_string}#{file_string}"
      OpenSSL::HMAC.hexdigest(DIGEST, callback_token, callback_data)
    end

    private

    def generate_params_string(params)
      sorted_params = params.sort_by { |key, _value| key }
      params_strings = sorted_params.map { |key, value| "#{key}#{value}" }
      params_strings.join
    end

    def generate_files_string(files)
      files_array = files_to_array(files).reject(&:nil?)
      sorted_files = files_array.sort_by { |file| file[:name] }
      files_strings = sorted_files.map { |file| generate_file_string(file) }
      files_strings.join
    end

    def files_to_array(files)
      files.is_a?(Array) ? files : [files]
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
