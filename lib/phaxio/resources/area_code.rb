module Phaxio
  module Resources
    # Information about area codes for provisioning numbers.
    #
    # @see Phaxio::Resources::PhoneNumber.list_available_area_codes
    class AreaCode < Resource
      # @!attribute country_code
      # @!attribute area_code
      # @!attribute city
      # @!attribute state
      # @!attribute country
      # @!attribute toll_free
      has_normal_attributes %w[country_code area_code city state country toll_free]
    end
  end
end
