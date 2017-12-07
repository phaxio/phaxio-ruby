module Phaxio
  module Resources
    # Provides functionality for viewing and managing phone numbers.
    class PhoneNumber < Resource
      PHONE_NUMBERS_PATH = 'phone_numbers'.freeze
      AVAILABLE_AREA_CODES_PATH = 'public/area_codes'.freeze
      private_constant :PHONE_NUMBERS_PATH, :AVAILABLE_AREA_CODES_PATH

      # @return [String] The phone number itself, in E.164 format.
      # @!attribute phone_number

      # @return [String] The city associated with the phone number.
      # @!attribute city

      # @return [String] The state associated with the phone number.
      # @!attribute state

      # @return [String] The country associated with the phone number.
      # @!attribute country

      # @return [Integer] The cost of the phone number in cents.
      # @!attribute cost

      # @return [String] The callback URL associated with the phone number.
      # @!attribute callback_url

      has_normal_attributes %w(phone_number city state country cost callback_url)

      # @return [Time] The time at which the phone number was provisioned.
      # @!attribute provisioned_at

      # @return [Time] The last time the phone number was billed.
      # @!attribute last_billed_at

      has_time_attributes %w(provisioned_at last_billed_at)

      private

      class << self
        # Provision a new phone number.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio:
        #   - *country_code* [Integer] - The country code (E.164) of the number you'd like to provision.
        #   - *area_code* [Integer] - The area code of the number you'd like to provision.
        #   - *callback_url* [String] - A callback URL that we'll post to when a fax is received by this number. This will override the global receive callback URL, if you have one specified.
        # @return [Phaxio::Resources::PhoneNumber] The newly provisioned number.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/phone_numbers/provision
        def create params = {}
          response = Client.request :post, phone_numbers_endpoint, params
          response_record response
        end
        alias :provision :create

        # Get information about a specific phone number.
        # @param phone_number [String]
        #   The phone number itself, in E.164 format, which you want to get information about.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio. This action has no unique parameters.
        # @return [Phaxio::Resources::PhoneNumber] The requested number.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/phone_numbers/get_number
        def get phone_number, params = {}
          response = Client.request :get, phone_number_endpoint(phone_number), params
          response_record response
        end
        alias :find :get
        alias :retrieve :get

        # @macro paging
        # Get a list of phone numbers that you currently own on Phaxio.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio.
        #   - *country_code* [Integer] - An E.164 country code that you'd like to filter by.
        #   - *area_code* [Integer] - An area code that you'd like to filter by. If an area code is
        #     specified, then *country_code* is required.
        # @return [Phaxio::Resource::Collection<Phaxio::Resources::PhoneNumber>]
        #   A collection of phone numbers.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/phone_numbers/list
        def list params = {}
          response = Client.request :get, phone_numbers_endpoint, params
          response_collection response
        end

        # Release a phone number that you no longer need. Once a phone number is released you will
        # no longer be charged for it.
        # @param phone_number [String]
        #   The phone number itself, in E.164 format, which you want to release.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio. This action has no unique parameters.
        # @return true
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/phone_numbers/release
        def delete phone_number, params = {}
          Client.request :delete, phone_number_endpoint(phone_number), params
          true
        end
        alias :release :delete

        # @macro paging
        # Displays a list of area codes available for purchasing Phaxio numbers. This operation
        # requires no authentication and can be used without passing an API key.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio.
        #   - *toll_free* [true|false] - If set to *true*, only toll free area codes will be
        #     returned. If specified and set to *false*, only non-toll free area codes will be
        #     returned.
        #   - *country_code* [Integer] - An E.164 country code you'd like to filter by.
        #   - *country* [String] - A two character country abbreviation (ISO 3166; e.g. "US" or
        #     "CA") you'd like to filter by.
        #   - *state* [String] - A two character state or province abbreviation (ISO 3166; e.g.
        #     "IL" or "YT") you'd like to filter by. When using this parameter, *country_code* or
        #     *country* must also be provided.
        # @return [Phaxio::Resource::Collection<Phaxio::Resources::AreaCode>] A collection of
        #   AreaCode objects.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/public/list_area_codes
        def list_available_area_codes params = {}
          response = Client.request :get, available_area_codes_endpoint, params
          AreaCode.response_collection response
        end

        private

        def phone_numbers_endpoint
          PHONE_NUMBERS_PATH
        end

        def available_area_codes_endpoint
          AVAILABLE_AREA_CODES_PATH
        end

        def phone_number_endpoint phone_number
          "#{phone_numbers_endpoint}/#{phone_number}"
        end
      end
    end
  end
end
