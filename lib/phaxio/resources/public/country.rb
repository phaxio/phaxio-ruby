module Phaxio
  module Resources
    module Public
      class Country < Resource
        SUPPORTED_COUNTRIES_PATH = 'public/countries'.freeze
        private_constant :SUPPORTED_COUNTRIES_PATH

        # @return [String] the name of the country.
        # @!attribute name

        # @return [String] the alpha2 representation of the country.
        # @!attribute alpha2

        # @return [Integer] the E.164 country code for the country.
        # @!attribute country_code

        # @return [Integer] the price per page for the country, in cents.
        # @!attribute price_per_page

        # @return [String] the level of send support provided for this country.
        # @!attribute send_support

        # @return [String] the level of receive support provided for this country.
        # @!attribute receive_support

        has_normal_attributes %w[
          name alpha2 country_code price_per_page send_support receive_support
        ]

        class << self
          # @macro paging
          # Get a list of supported countries for sending faxes.
          # @param params [Hash]
          #   A hash of parameters to send to Phaxio. This action has no unique
          #   parameters.
          # @return [Phaxio::Resource::Collection<Phaxio::Resources::Country>]
          #   A collection of supported countries.
          # @raise Phaxio::Error::PhaxioError
          # @see https://www.phaxio.com/docs/api/v2/public/list_countries
          def list params = {}
            response = Client.request :get, supported_countries_endpoint, params
            Country.response_collection response
          end

          private

          def supported_countries_endpoint
            SUPPORTED_COUNTRIES_PATH
          end
        end
      end
    end
  end
end
