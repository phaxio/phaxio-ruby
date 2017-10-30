module Phaxio
  module Resources
    class Fax
      FAXES_PATH = 'faxes'.freeze

      class Reference
        attr_accessor :id

        def initialize id
          self.id = id
        end
      end

      class Collection
        attr_accessor :raw_data

        def initialize raw_data
          self.raw_data = raw_data
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
          response = Client.request :get, fax_endpoint(id), {}, options
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

        private

        def response_reference response
          Reference.new response['id']
        end

        def response_record response
          Fax.new response
        end

        def response_collection response
          Fax::Collection.new response
        end

        def faxes_endpoint
          FAXES_PATH
        end

        def fax_endpoint id
          "#{FAXES_PATH}/#{id}"
        end

        def cancel_fax_endpoint id
          "#{fax_endpoint(id)}/cancel"
        end

        def resend_fax_endpoint id
          "#{fax_endpoint(id)}/resend"
        end
      end

      attr_accessor :raw_data, :id

      def initialize raw_data
        self.raw_data = raw_data
        self.id = raw_data['id']
      end
    end
  end
end
