module Phaxio
  module Resources
    class Fax
      CREATE_FAX_ENDPOINT = 'faxes/'

      class << self
        def create params = {}, options = {}
          Client.request :post, CREATE_FAX_ENDPOINT, params, options
        end
      end
    end
  end
end
