module Phaxio
  module Resources
    # Provides functionality for viewing and managing phone numbers.
    class PhoneNumber < Resource
      PHONE_NUMBERS_PATH = 'phone_numbers'.freeze
      AVAILABLE_AREA_CODES_PATH = 'public/area_codes'.freeze
      private_constant :PHONE_NUMBERS_PATH, :AVAILABLE_AREA_CODES_PATH

      # @!attribute phone_number
      # @!attribute city
      # @!attribute state
      # @!attribute country
      # @!attribute cost
      # @!attribute callback_url
      has_normal_attributes %w(phone_number city state country cost callback_url)
      # @!attribute provisioned_at
      # @!attribute last_billed_at
      has_time_attributes %w(provisioned_at last_billed_at)

      private

      class << self
        # Provisions a new phone number.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio:
        #     - "country_code": The country code where you wish to provision the number.
        #     - "area_code": The area code where you wish to provision the number.
        # @param options [Hash]
        # @return [Phaxio::Resources::PhoneNumber] The newly provisioned number.
        # @raise Phaxio::Error::PhaxioError
        def create params = {}, options = {}
          response = Client.request :post, phone_numbers_endpoint, params, options
          response_record response
        end
        alias :provision :create

        def get phone_number, options = {}
          response = Client.request :get, phone_number_endpoint(phone_number), {}, options
          response_record response
        end
        alias :find :get
        alias :retrieve :get

        def list params = {}, options = {}
          response = Client.request :get, phone_numbers_endpoint, params, options
          response_collection response
        end

        def delete phone_number, options = {}
          Client.request :delete, phone_number_endpoint(phone_number), {}, options
          true
        end
        alias :release :delete

        def list_available_area_codes params = {}, options = {}
          response = Client.request :get, available_area_codes_endpoint, params, options
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
