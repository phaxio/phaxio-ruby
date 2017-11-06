module Phaxio
  module Resources
    # Information about your Phaxio account.
    class Account < Resource
      ACCOUNT_PATH = 'account'
      private_constant :ACCOUNT_PATH

      # @!attribute balance
      # @!attribute faxes_today
      # @!attribute faxes_this_month
      has_normal_attributes %w[balance faxes_today faxes_this_month]

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
