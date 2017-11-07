module Phaxio
  module Resources
    # Information about area codes for provisioning numbers.
    #
    # @see Phaxio::Resources::PhoneNumber.list_available_area_codes
    class AreaCode < Resource
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
    end
  end
end
