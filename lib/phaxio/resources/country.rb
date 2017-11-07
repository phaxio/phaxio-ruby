module Phaxio
  module Resources
    class Country < Resource
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
    end
  end
end