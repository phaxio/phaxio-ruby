module Phaxio
  module Resources
    class PhaxCode < Resource
      PHAX_CODES_PATH = 'phax_codes'.freeze
      DEFAULT_PHAX_CODE_PATH = 'phax_code'.freeze

      # @!attribute identifier
      # @!attribute metadata
      has_normal_attributes %w[identifier metadata]

      # @!attribute created_at
      has_time_attributes %w[created_at]

      class << self
        def create params = {}, options = {}
          endpoint = case (params[:type] || params['type']).to_s
            when 'png' then phax_codes_endpoint_png
            else phax_codes_endpoint
          end
          result = Client.request :post, endpoint, params, options
          return result if result.is_a? File
          response_record result
        end

        def get params = {}, options = {}
          identifier = params[:identifier] || params['identifier']
          endpoint = case (identifier)
            when nil then default_phax_code_path
            else phax_code_endpoint(identifier)
          end
          endpoint = case (params[:type] || params['type']).to_s
            when 'png' then "#{endpoint}.png"
            else endpoint
          end
          result = Client.request :get, endpoint, {}, options
          return result if result.is_a? File
          response_record result
        end

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