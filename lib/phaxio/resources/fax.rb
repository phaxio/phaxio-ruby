module Phaxio
  module Resources
    # Provides functionality for viewing and managing faxes.
    class Fax < Resource
      FAXES_PATH = 'faxes'.freeze
      SUPPORTED_COUNTRIES_PATH = 'public/countries'.freeze
      private_constant :FAXES_PATH, :SUPPORTED_COUNTRIES_PATH

      # @return [Integer] The ID associated with this fax.
      # @!attribute id

      # @return ["sent" | "received"] The direction of the fax.
      # @!attribute direction

      # @return [Integer] The number of pages in the fax.
      # @!attribute num_pages

      # @return [Integer] The cost of the fax in cents.
      # @!attribute cost

      # @return [String] The status of the fax.
      # @!attribute status

      # @return [true | false] Indicates whether or not this is a test fax.
      # @!attribute is_test

      # @return [String]
      #   For sent faxes, the number set as the Caller ID when sending the fax.
      # @!attribute caller_id

      # @return [String]
      #   For received faxes, this is the sender's E.164 phone number.
      # @!attribute from_number

      # @return [String]
      #   For received faxes, this is the Phaxio phone number that was used to
      #   receive the call.
      # @!attribute to_number

      # @return [String]
      #   One of the Phaxio error types. Will give you a general idea of what
      #   went wrong for a failed fax.
      # @!attribute error_type

      # @return [String]
      #   A more detailed description of what went wrong for a failed fax.
      # @!attribute error_message

      # @return [Integer]
      #   A numeric error code that corresponds to the error message, if any.
      # @!attribute error_id

      # @return [Hash]
      #   A hash of tag name and value pairs. If a fax was sent with tag
      #   metadata, it will appear here.
      # @!attribute tags
      has_normal_attributes %w[
        id direction num_pages cost status is_test caller_id from_number
        to_number error_type error_message error_id tags
      ]

      # @return [Time] The time the fax was created.
      # @!attribute created_at

      # @return [Time] The time the fax was completed.
      # @!attribute completed_at

      has_time_attributes %w[created_at completed_at]

      # @return [Phaxio::Resource::Collection<Phaxio::Resources::FaxRecipient>]
      #   A collection of this fax's recipients.
      # @!attribute recipients

      has_collection_attributes({recipients: FaxRecipient})

      class Reference
        attr_accessor :id

        def initialize id
          self.id = id
        end

        def get
          Fax.get self
        end
        alias :retrieve :get
        alias :find :get

        def to_i
          id
        end
      end

      class << self
        def list params = {}
          response = Client.request :get, faxes_endpoint, params
          response_collection response
        end

        def create params = {}
          response = Client.request :post, faxes_endpoint, params
          response_reference response
        end
        alias :send :create

        def get id, params = {}
          response = Client.request :get, fax_endpoint(id.to_i), params
          response_record response
        end
        alias :retrieve :get
        alias :find :get

        def cancel id, params = {}
          response = Client.request :post, cancel_fax_endpoint(id), params
          response_reference response
        end

        def resend id, params = {}
          response = Client.request :post, resend_fax_endpoint(id), params
          response_reference response
        end

        def delete id, params = {}
          Client.request :delete, fax_endpoint(id), params
          true
        end

        def delete_file id, params = {}
          Client.request :delete, fax_file_endpoint(id), params
          true
        end

        def file id, params = {}
          Client.request :get, fax_file_endpoint(id), params
        end

        def test_receive params = {}
          Client.request :post, faxes_endpoint, test_receive_params(params)
          true
        end

        def supported_countries params = {}
          response = Client.request :get, supported_countries_endpoint, params
          Country.response_collection response
        end

        private

        def response_reference response
          Reference.new response['id']
        end

        def faxes_endpoint
          FAXES_PATH
        end

        def fax_endpoint id
          "#{FAXES_PATH}/#{id}"
        end

        def fax_file_endpoint id
          "#{fax_endpoint(id)}/file"
        end

        def cancel_fax_endpoint id
          "#{fax_endpoint(id)}/cancel"
        end

        def resend_fax_endpoint id
          "#{fax_endpoint(id)}/resend"
        end

        def supported_countries_endpoint
          SUPPORTED_COUNTRIES_PATH
        end

        def test_receive_params params
          {direction: 'received'}.merge(params)
        end
      end
    end
  end
end
