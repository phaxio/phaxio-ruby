module Phaxio
  module Resources
    class PhaxCode < Resource
      PHAX_CODES_PATH = 'phax_codes'.freeze

      class << self
        def create params = {}, options = {}
          endpoint = case params[:type].to_s
            when 'png' then phax_codes_endpoint_png
            else phax_codes_endpoint
          end
          result = Client.request :post, endpoint, params, options
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
      end
    end
  end
end