module Phaxio
  include  HTTMultiParty
  base_uri 'https://api.phaxio.com/v1'

  module Config
    attr_accessor :api_key, :api_secret, :callback_token
  end

  module Client
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

    # Public: This method attaches a PhaxCode to a PDF file you provide.
    # Example:

    #    Phaxio.attach_phaxcode_to_pdf(x: "0", y: "100", filename: "#{Rails.root}/path/to/test.pdf")

    # Required parameters are (x, y, filename):
    # x -- Type: float. The X-coordinate (in PDF points*) of where the PhaxCode should be drawn. x=0 is the left most point of the page.

    #*PDF points definition: A "point" is 1/72 of an inch. An 8.5"x11" document is therefore 612 pt x 792 pt.

    # y -- Type: float. The Y-coordinate (in PDF points*) of where the PhaxCode should be drawn. y=0 is the bottom most point of the page.

    # filename -- Type: binary stream. The PDF file to which you want to add the barcode.

    #Optional parameters: (metadata, page number)

    # metadata -- Type: string. Custom metadata to be associated with the created barcode. If not present, the basic PhaxCode for your account will be used.

    # page number -- Type: integer. The page where the PhaxCode should be drawn. 1-based!!

    #Response: A PDF file containing a PhaxCode at the location specified.

    def attach_phaxcode_to_pdf(options)
      if options[:filename].nil?
        raise StandardError, "You must include a PDF file."
      end

      if(options[:x] < 0 || options[:y] < 0)
        raise StandardError, "Coordinates must be greater than or equal to 0."
      end
        send_post("/attachPhaxCodeToPdf", options)
    end

    #Public This method creates a PhaxCode. Although neither parameter is required, omitting "redirect" will return a JSON object instead of the PhaxCode image.

    #Example:
    #  Phaxio.create_phaxcode

    # metadata -- Type: string. Custom metadata to be associated with this barcode. If not present, the basic PhaxCode for your account will be used.

    # redirect -- Type: boolean. If present and true, the PhaxCode barcode image will be dumped in the response.

    #Response: If the redirect parameter is not provided, a JSON object with success, message, and data attributes is returned. The data attribute contains a url where the PhaxCode barcode image can be accessed.Otherwise, the image data is dumped in the response.

    def create_phaxcode(options)
        send_post("/createPhaxCode", options)
    end

    #This method will return a PDF of a document hosted by Phaxio with a PhaxCode attached. Note: You will have to set up the hosted document with Phaxio (along with the relevant PhaxCode) before calling this method.

    #Required parameter:
    # name -- Type: string. The name of a hosted document.

    #Optional parameter:
    # metadata -- Type: string. Custom metadata to be associated with the PhaxCode that will be attached to the hosted document. If not present, the basic PhaxCode for your account will be used.

    #Response: A PDF copy of the hosted document with a PhaxCode included at the pre-specified location.

    def get_hosted_document(options)
        if options[:name].nil?
          raise StandardError, "You must include the name of the hosted document."
        end
        send_post("/getHostedDocument", options)
    end

    #This method doesn't require API keys and is included for the sake of completion. It returns a list of countries that can send faxes along with the country's cost per page.

    #Example:
    #  Phaxio.supported_countries

    #Response: A JSON object with success, message, and data attributes. The data attribute contains a hash, where the key contains the name of the country, and the value is a hash of attributes for the country (currently only pricing information).

    #Example Response:
    #{
    #"success": true,
    #"message": "Data contains supported countries.",
    #"data": {
    #    "United States": {
    #        "price_per_page": 7
    #    },
    #    "Canada": {
    #        "price_per_page": 7
    #    }, ... etc.

    def supported_countries
      post("/supportedCountries")
    end

    #Another method that doesn't require API credentials but is included for the sake of completion. This method will return a list of area codes that have Phaxio numbers available for purchase.

    #Parameters (both optional):

    # is_toll_free -- Type: boolean. Will only return toll free area codes

    # state -- Type: string. A two character state or province abbreviation (e.g. IL or YT). Will only return area codes available for this state.

    #Response: A JSON object with success, message, and data attributes. The data attribute contains a map of area codes to city and state.

    #Example response:
    #{
    #"success": true,
    #"message": "295 area codes available.",
    #"data": {
    #    "201": {
    #        "city": "Bayonne, Jersey City, Union City",
    #        "state": "New Jersey"
    #    },
    #    "202": {
    #        "city": "Washington",
    #        "state": "District Of Columbia"
    #    },
    #    ... a lot more area codes here...
    #}

    def area_codes
      post("/areaCodes")
    end

    def send_post(path, options)
      post(path, query: options.merge!({api_key: api_key, api_secret: api_secret}))
    end
  end

  # Public: Configure Phaxio with your api_key and api_secret
  #
  # Examples
  #
  #   Phaxio.config do |config|
  #      config.api_key = "12345678910"
  #      config.api_secret = "10987654321"
  #      config.callback_token = "32935829"
  #    end
  #
  # Returns nothing.
  def self.config
    yield(self)
  end

  extend Client
  extend Config
end
