module Phaxio
  module Resources
    # Provides functionality for viewing port number notes.
    class PortNumberNote < Resource
      PORT_NUMBERS_PATH = 'port_numbers'.freeze
      private_constant :PORT_NUMBERS_PATH
      NOTES_PATH = 'notes'.freeze
      private_constant :NOTES_PATH

      # @return [Integer] the ID associated with this note.
      # @!attribute id

      # @return [String] the author of this note.
      # @!attribute author

      # @return [String] the content of the note
      # @!attribute note

      has_normal_attributes %w[id note author]

      # @return [Time] the time this note was created.
      # @!attribute created_at
      
      # @return [Time] the time this note was updated.
      # @!attribute updated_at

      has_time_attributes %w[created_at updated_at]

      class << self
        # List notes for a port number.
        # @param port_number_id [Integer]
        #   The ID of the port number to list notes for.
        # @param params [Hash]
        #   Any parameters to send to Phaxio. This action takes no unique parameters.
        # @return [Phaxio::Resource::Collection<Phaxio::Resources::PortNumberNote>]
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/port_number_notes/list_notes
        def list port_number_id, params = {}
          response = Client.request :get, port_number_notes_endpoint(port_number_id.to_i), params
          response_collection response
        end
        
        private

        def port_number_notes_endpoint port_number_id
          "#{PORT_NUMBERS_PATH}/#{port_number_id}/#{NOTES_PATH}"
        end
      end
    end
  end
end
