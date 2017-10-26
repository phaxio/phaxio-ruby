module Phaxio
  module Resources
    class Fax
      CREATE_FAX_ENDPOINT = 'faxes/'

      class Reference
        attr_accessor :id

        def initialize id
          self.id = id
        end
      end

      class << self
        def create params = {}, options = {}
          response = Client.request :post, CREATE_FAX_ENDPOINT, params, options
          return_reference response
        end

        private
        
        def return_reference response
          Reference.new JSON.parse(response.body)['data']['id']
        end
      end
    end
  end
end
