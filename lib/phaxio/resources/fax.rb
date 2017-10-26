module Phaxio
  module Resources
    class Fax
      FAXES_PATH = 'faxes/'.freeze

      class Reference
        attr_accessor :id

        def initialize id
          self.id = id
        end
      end

      class << self
        def create params = {}, options = {}
          response = Client.request :post, faxes_endpoint, params, options
          get_response_reference response
        end
        alias :send :create

        def get id, options = {}
          response = Client.request :get, fax_endpoint(id), {}, options
        end

        private
        
        def get_response_reference response
          Reference.new JSON.parse(response.body)['data']['id']
        end

        def faxes_endpoint
          FAXES_PATH
        end

        def fax_endpoint id
          "#{FAXES_PATH}#{id}/"
        end
      end
    end
  end
end
