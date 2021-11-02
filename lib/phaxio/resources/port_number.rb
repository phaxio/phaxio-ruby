module Phaxio
  module Resources
    # Provides functionality for viewing port numbers.
    class PortNumber < Resource
      PORT_NUMBERS_PATH = 'port_numbers'.freeze
      private_constant :PORT_NUMBERS_PATH

      # @return [Integer] the ID associated with this number.
      # @!attribute id

      # @return [String] the E.164 number.
      # @!attribute port_number

      # @return [String] the status of this number.
      # @!attribute status
      
      has_normal_attributes %w(id port_number status)

      class << self
        # Get port number info.
        # @param id [Integer] The ID of the number to retrieve.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio. This action takes no unique parameters.
        # @return [Phaxio::Resource::PortNumber]
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/port_numbers/get_port_number
        def get id, params = {}
          response = Client.request :get, port_number_endpoint(id.to_i), params
          response_record response
        end
        alias :retrieve :get
        alias :find :get

        private

        def port_number_endpoint id
          "#{PORT_NUMBERS_PATH}/#{id}"
        end
      end
    end
  end
end
