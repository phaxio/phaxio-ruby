module Phaxio
  module Resources
    class FaxRecipient < Resource
      # @return [String] The phone number of the recipient in E.164 format.
      # @!attribute phone_number

      # @return [String] The status of the recipient.
      # @!attribute status

      # @return [Integer] The number of retries for this recipient.
      # @!attribute retry_count

      # @return [Integer] The bitrate in bits/second that the fax was transmitted at.
      # @!attribute bitrate

      # @return [Integer]
      #   The horizontal resolution that the fax was transmitted at in pixels per meter.
      # @!attribute resolution

      # @return [String]
      #   One of the Phaxio Error types. Will give you a general idea of what went wrong for this
      #   recipient.
      # @!attribute error_type

      # @return [String] A more detailed description of what went wrong for this receipient.
      # @!attribute error_message

      # @return [Integer] A numeric error code that corresponds to the error message, if any.
      # @!attribute error_id

      has_normal_attributes %w[
        phone_number status retry_count bitrate resolution error_type error_message error_id
      ]

      # @return [Time] The time the job was completed for this recipient.
      # @!attribute completed_at

      has_time_attributes %w[completed_at]
    end
  end
end