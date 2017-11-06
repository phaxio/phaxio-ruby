module Phaxio
  module Resources
    class FaxRecipient < Resource
      # @!attribute phone_number
      # @!attribute status
      # @!attribute retry_count
      # @!attribute bitrate
      # @!attribute resolution
      # @!attribute error_type
      # @!attribute error_message
      # @!attribute error_id
      has_normal_attributes %w[
        phone_number status retry_count bitrate resolution error_type error_message error_id
      ]

      # @!attribute completed_at
      has_time_attributes %w[completed_at]
    end
  end
end