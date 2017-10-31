module Phaxio
  module Resources
    class Account < Resource
      ACCOUNT_PATH = 'account'

      class << self
        def get options = {}
          response = Client.request :get, account_status_endpoint, {}, options
          response_record response
        end
        alias :status :get
        alias :retrieve :get

        def account_status_endpoint
          "#{ACCOUNT_PATH}/status"
        end
      end
    end
  end
end
