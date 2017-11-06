module Phaxio
  module Resources
    # Provides functionality for viewing and managing faxes.
    class Fax < Resource
      FAXES_PATH = 'faxes'.freeze
      SUPPORTED_COUNTRIES_PATH = 'public/countries'.freeze
      private_constant :FAXES_PATH, :SUPPORTED_COUNTRIES_PATH

      # @!attribute id
      # @!attribute direction
      # @!attribute num_pages
      # @!attribute cost
      # @!attribute status
      # @!attribute is_test
      # @!attribute caller_id
      # @!attribute from_number
      # @!attribute to_number
      # @!attribute error_type
      # @!attribute error_message
      # @!attribute error_id
      # @!attribute tags
      has_normal_attributes %w[
        id direction num_pages cost status is_test caller_id from_number
        to_number error_type error_message error_id tags
      ]

      # @!attribute created_at
      # @!attribute completed_at
      has_time_attributes %w[created_at completed_at]

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
        def list params = {}, options = {}
          response = Client.request :get, faxes_endpoint, params, options
          response_collection response
        end

        def create params = {}, options = {}
          response = Client.request :post, faxes_endpoint, params, options
          response_reference response
        end
        alias :send :create

        def get id, options = {}
          response = Client.request :get, fax_endpoint(id.to_i), {}, options
          response_record response
        end
        alias :retrieve :get
        alias :find :get

        def cancel id, options = {}
          response = Client.request :post, cancel_fax_endpoint(id), {}, options
          response_reference response
        end

        def resend id, options = {}
          response = Client.request :post, resend_fax_endpoint(id), {}, options
          response_reference response
        end

        def delete id, options = {}
          Client.request :delete, fax_endpoint(id), {}, options
          true
        end

        def delete_file id, options = {}
          Client.request :delete, fax_file_endpoint(id), {}, options
          true
        end

        def file id, options = {}
          Client.request :get, fax_file_endpoint(id), {}, options
        end

        def test_receive params = {}, options = {}
          Client.request :post, faxes_endpoint, test_receive_params(params), options
          true
        end

        def supported_countries params = {}, options = {}
          response = Client.request :get, supported_countries_endpoint, params, options
          response_collection response
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
