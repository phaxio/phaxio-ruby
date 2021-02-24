module Phaxio
  module Resources
    # Provides functionality for managing ATAs.
    class Ata < Resource
      ATAS_PATH = 'atas'.freeze
      private_constant :ATAS_PATH

      # @return [Integer] the ID of the ATA.
      # @!attribute id

      # @return [String] the name of the ATA.
      # @!attribute name

      # @return [String] the description of the ATA.
      # @!attribute description

      # @return [String] The user phone number associated with the ATA.
      # @!attribute user_phone_number

      # @return [String] The domain for the ATA.
      # @!attribute domain

      # @return [String] The username for the ATA.
      # @!attribute uername

      # @return [String] The password for the ATA.
      # @!attribute password

      has_normal_attributes %w[
        id name description user_phone_number domain username password
      ]

      # A reference to an ATA. This is returned by certain actions which don't
      # return the full ATA.
      class Reference
        # @return [Integer]
        #   The ID of the referenced ATA.
        attr_accessor :id

        def to_i
          id
        end

        private

        def initialize id
          self.id = id
        end
      end

      # A reference to a phone number, returned by ATA phone number management
      # actions.
      class PhoneNumberReference
        # @return [String]
        #   The phone number.
        attr_accessor :phone_number

        def to_s
          phone_number
        end

        private

        def initialize phone_number
          self.phone_number = phone_number
        end
      end

      class << self
        # @macro paging
        # List ATAs
        # @param params[Hash]
        #   Any parameters to send to Phaxio.
        # @return [Phaxio::Resource::Collection<Phaxio::Resources::Ata>]
        #   The collection of ATAs matching your request.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2.1/atas/list
        def list params = {}
          response = Client.request :get, atas_endpoint, params
          response_collection response
        end

        # Create an ATA
        # @param params [Hash]
        #   Any parameters to send to Phaxio.
        #   - *name* [String] - A name used to identify the ATA.
        #   - *description* [String] - A longer description of the ATA.
        #   - *domain* [String] - A domain for the ATA.
        # @return [Phaxio::Resources::Ata]
        #   The created ATA, including the generated username and password.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2.1/atas/create
        def create params = {}
          response = Client.request :post, atas_endpoint, params
          response_record response
        end

        # Get an ATA
        # @param id [Integer]
        #   The ID of the ATA to retrieve information about.
        # @param params [Hash]
        #   Any parameters to send to Phaxio. This action takes no unique parameters.
        # @return [Phaxio::Resources::Ata]
        #   The requested ATA.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2.1/atas/get
        def get id, params = {}
          response = Client.request :get, ata_endpoint(id.to_i), params
          response_record response
        end
        alias :retrieve :get
        alias :find :get

        # Update an ATA
        # @param id [Integer]
        #   The ID of the ATA to update.
        # @param params [Hash]
        #   Any parameters to send to Phaxio.
        #   - *name* [String] - A name used to identify the ATA.
        #   - *description* [String] - A longer description of the ATA.
        #   - *domain* [String] - A domain for the ATA.
        # @return [Phaxio::Resources::Ata]
        #   The updated ATA.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2.1/atas/update
        def update id, params = {}
          response = Client.request :patch, ata_endpoint(id.to_i), params
          response_record response
        end

        # Regenerate credentials for an ATA
        # @param id [Integer]
        #   The ID of the ATA for which credentials should be regenerated.
        # @param params [Hash]
        #   Any parameters to send to Phaxio. This action takes no unique parameters.
        # @return [Phaxio::Resources::Ata]
        #   The ATA, including the new username and password.
        # @raise Phaxio::Error::PhaxioError
        # @see https://www.phaxio.com/docs/api/v2.1/atas/regenerate_credentials
        def regenerate_credentials id, params = {}
          response = Client.request :patch, regenerate_credentials_endpoint(id.to_i), params
          response_record response
        end

        # Delete an ATA
        # @param id [Integer]
        #   The Id of the ATA to delete.
        # @param params [Hash]
        #   Any parameters to send to Phaxio. This action takes no unique parameters.
        # @return [Phaxio::Resources::Ata::Reference]
        #   A reference to the deleted ATA.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2.1/atas/delete
        def delete id, params = {}
          response = Client.request :delete, ata_endpoint(id.to_i), params
          response_reference response
        end

        # Add a phone number
        # @param id [Integer]
        #   The ID of the ATA to which you want to add a number.
        # @param phone_number [String]
        #   The phone number to add to the ATA.
        # @param params [Hash]
        #   Any parameters to send to Phaxio. This action takes no unique parameters.
        # @return [Phaxio::Resources::Ata::PhoneNumberReference]
        #   A reference to the added phone number.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2.1/atas/add_phone_number
        def add_phone_number id, phone_number, params = {}
          response = Client.request :post, phone_number_endpoint(id, phone_number), params
          response_phone_number_reference response
        end

        # Remove a phone number
        # @param id [Integer]
        #   The ID of the ATA from which you want to remove the phone number.
        # @param phone_number [String]
        #   The phone number you want to remove.
        # @param params [Hash]
        #   Any parameters to send to Phaxio. This action takes no unique parameters.
        # @return [Phaxio::Resources::Ata::PhoneNumberReference]
        #   A reference to the removed phone number.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2.1/atas/remove_phone_number
        def remove_phone_number id, phone_number, params = {}
          response = Client.request :delete, phone_number_endpoint(id, phone_number), params
          response_phone_number_reference response
        end

        private

        def response_reference response
          Reference.new Integer(response['id'])
        end

        def response_phone_number_reference response
          PhoneNumberReference.new(response['phone_number'])
        end

        def atas_endpoint
          ATAS_PATH
        end

        def ata_endpoint id
          "#{atas_endpoint}/#{id}"
        end

        def regenerate_credentials_endpoint id
          "#{ata_endpoint(id)}/regenerate_credentials"
        end

        def phone_number_endpoint id, phone_number
          "#{ata_endpoint(id)}/phone_numbers/#{phone_number}"
        end
      end
    end
  end
end
