module Phaxio
  module Resources
    class Country < Resource
      has_normal_attributes %w[
        name alpha2 country_code price_per_page send_support receive_support
      ]
    end
  end
end