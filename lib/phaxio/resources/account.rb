module Phaxio
  module Resources
    # Information about your Phaxio account.
    class Account < Resource
      ACCOUNT_PATH = 'account'

      class << self
        # Get information about your Phaxio account, including your balance, number of faxes sent
        # today, and number of faxes sent this week.
        #
        # @see https://www.phaxio.com/docs/api/v2/account/status
        def get options = {}
          response = Client.request :get, account_status_endpoint, {}, options
          response_record response
        end
        alias :status :get
        alias :retrieve :get

        private

        def account_status_endpoint
          "#{ACCOUNT_PATH}/status"
        end
      end
    end
  end
end
