module Phaxio
  module Resources
    # Provides functionality for viewing and managing PhaxCodes.
    class PhaxCode < Resource
      PHAX_CODES_PATH = 'phax_codes'.freeze
      DEFAULT_PHAX_CODE_PATH = 'phax_code'.freeze
      private_constant :PHAX_CODES_PATH, :DEFAULT_PHAX_CODE_PATH

      # @return [String] The identifier for the PhaxCode.
      # @!attribute identifier

      # @return [String] The metadata associated with the PhaxCode.
      # @!attribute metadata

      has_normal_attributes %w[identifier metadata]

      # @return [Time] The time that the PhaxCode was created.
      # @!attribute created_at

      has_time_attributes %w[created_at]

      class << self
        # Create a PhaxCode.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio.
        #   - *metadata* [String] - Metadata to be associated with the PhaxCode.
        #   - *type* [String] - If set to "png", this method will return a PNG
        #     file instead of a PhaxCode object.
        # @return [Phaxio::Resources::PhaxCode | File] The created PhaxCode
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/phaxcodes/create_phax_code
        def create params = {}
          endpoint = case (params[:type] || params['type']).to_s
            when 'png' then phax_codes_endpoint_png
            else phax_codes_endpoint
          end
          result = Client.request :post, endpoint, params
          return result if result.is_a? File
          response_record result
        end

        # Retrieve a PhaxCode.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio.
        #   - *identifier* [String] - The identifier for the PhaxCode you want to get. If blank, the
        #     default PhaxCode will be returned.
        #   - *type* [String] - If set to "png", this method will return a PNG file instead of a
        #     PhaxCode object.
        # @return [Phaxio::Resources::PhaxCode | File]
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/phaxcodes/retrieve_phax_code
        def get params = {}
          identifier = params[:identifier] || params['identifier']
          endpoint = case (identifier)
            when nil then default_phax_code_path
            else phax_code_endpoint(identifier)
          end
          endpoint = case (params[:type] || params['type']).to_s
            when 'png' then "#{endpoint}.png"
            else endpoint
          end
          result = Client.request :get, endpoint, {}
          return result if result.is_a? File
          response_record result
        end
        alias :find :get
        alias :retrieve :get

        private

        def phax_codes_endpoint
          PHAX_CODES_PATH
        end

        def phax_codes_endpoint_png
          "#{phax_codes_endpoint}.png"
        end

        def phax_code_endpoint(identifier)
          "#{phax_codes_endpoint}/#{identifier}"
        end

        def default_phax_code_path
          DEFAULT_PHAX_CODE_PATH
        end
      end
    end
  end
end