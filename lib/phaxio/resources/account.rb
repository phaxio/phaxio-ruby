module Phaxio
  module Resources
    # Information about your Phaxio account.
    class Account < Resource
      ACCOUNT_PATH = 'account'
      private_constant :ACCOUNT_PATH

      # @return [Integer] Your current account funds balance in cents.
      # @!attribute balance

      # @return [Hash<String: Integer>] A hash of the number of faxes sent and received today.
      # @!attribute faxes_today

      # @return [Hash<String: Integer>] A hash of the number of faxes sent and received this month.
      # @!attribute faxes_this_month
      has_normal_attributes %w[balance faxes_today faxes_this_month]

      class << self
        # Get information about your Phaxio account, including your balance, number of faxes sent
        # today, and number of faxes sent this week.
        # @param params [Hash]
        #   Any parameters to send to Phaxio. This action does not have any unique parameters.
        # @return [Phaxio::Resources::Acount] Your account information.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2.1/account/status
        def get params = {}
          response = Client.request :get, account_status_endpoint, params
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
