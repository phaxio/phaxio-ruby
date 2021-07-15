module Phaxio
  module Resources
    module Public
      # Information about area codes for provisioning numbers.
      #
      # @see Phaxio::Resources::PhoneNumber.list_available_area_codes
      class AreaCode < Resource
        AVAILABLE_AREA_CODES_PATH = 'public/area_codes'.freeze
        private_constant :AVAILABLE_AREA_CODES_PATH

        # @return [Integer] The country code associated with this area code.
        # @!attribute country_code

        # @return [Integer] The actual area code.
        # @!attribute area_code

        # @return [String] The city associated with this area code.
        # @!attribute city

        # @return [String] The state associated with this area code.
        # @!attribute state

        # @return [String] The country associated with this area code.
        # @!attribute country

        # @return [true | false] Indicates whether this area code is toll free.
        # @!attribute toll_free

        has_normal_attributes %w[country_code area_code city state country toll_free]

        class << self
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
          # @see https://www.phaxio.com/docs/api/v2.1/public/list_area_codes
          def list params = {}
            response = Client.request :get, available_area_codes_endpoint, params
            AreaCode.response_collection response
          end

          private

          def available_area_codes_endpoint
            AVAILABLE_AREA_CODES_PATH
          end
        end
      end
    end
  end
end
