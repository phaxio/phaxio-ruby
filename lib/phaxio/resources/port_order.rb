module Phaxio
  module Resources
    # Provides functionality for viewing and managing port orders.
    class PortOrder < Resource
      PORT_ORDERS_PATH = 'port_orders'.freeze
      private_constant :PORT_ORDERS_PATH

      # @return [Integer] the ID associated with this order.
      # @!attribute id

      # @return [String] the status of this order.
      # @!attribute status

      # @return [String] the E.164 contact number.
      # @!attribute contact_number

      # @return [String] the name associated with the account.
      # @!attribute name_on_account

      # @return [String] the name of the business.
      # @!attribute name_of_business

      # @return [String] the provider name.
      # @!attribute provider_name

      # @return [String] the E.164 billing number.
      # @!attribute billing_number

      # @return [String] the first billing address line.
      # @!attribute billing_address1

      # @return [String] the second billing address line.
      # @!attribute billing_address2
      
      # @return [String] the billing address city.
      # @!attribute billing_city

      # @return [String] the billing address state.
      # @!attribute billing_state

      # @return [String] the billing address zip.
      # @!attribute billing_zip
      
      # @return [String] the electronic signature used to sign the order.
      # @!attribute esig

      # @return [true | false]
      #   whether or not a bill will be provided. (only present on new orders)
      # @!attribute has_bill

      # @return [true | false]
      #   whether or not the legal agreement is accepted. (only present on new orders)
      # @!attribute legal_agreement

      has_normal_attributes %w[
        id contact_number name_on_account name_of_business provider_name
        billing_number billing_address1 billing_address2
        billing_city billing_state billing_zip esig legal_agreement
      ]

      # @return [Time] the time the order was created.
      # @!attribute created_at

      # @return [Time] the time the order was updated.
      # @!attribute updated_at

      # @return [Time] the time the bill for the order was received.
      # @!attribute bill_received_at

      # @return [Time] the time the order was requested for.
      # @!attribute requested_for

      # @return [Time] the time the order was completed.
      # @!attribute completed_at

      has_time_attributes %w[
        created_at updated_at bill_received_at requested_for completed_at
      ]

      # @return [Phaxio::Resource::Collection<Phaxio::Resources::PortNumber>]
      #   a collection of port numbers associated with the order
      # @!attribute port_numbers

      has_collection_attributes({port_numbers: PortNumber})

      class << self
        # @macro paging
        # List port orders in date range.
        # @param params [Hash]
        #   Any parameters to send to Phaxio.
        #   - *created_before* [String] - RFC 3339 timestamp representing the end of the range.
        #   - *created_after* [String] - RFC 3339 timestamp representing the beginning of the range.
        # @return [Phaxio::Resource::Collection<Phaxio::Resources::PortOrder>]
        #   The collection of port orders matching your request.
        # @raise [Phaxio::Error::PhaxioError
        # @see https://www.phaxio.com/docs/api/v2/port_orders/list_port_orders
        def list params = {}
          response = Client.request :get, port_orders_endpoint, params
          response_collection response
        end

        # Create a port order.
        # @param params [Hash]
        #   Any parameters to send to Phaxio.
        #   - *port_numbers* [Array<String>] - Numbers to port.
        #   - *contact_number* [String] - Number to contact about the port.
        #   - *name_on_account* [String] - Name on the account for the port.
        #   - *name_of_business* [String] - Name of business associated with the port.
        #   - *provider_name* [String] - Name of provider for the port.
        #   - *esig* [String] - Electronic signature used to sign the order.
        #   - *legal_agreement* [true | false] - Indicates acceptance of the legal agreement.
        #   - *has_bill* [true | false] - Indicates whether or not a bill will be provided.  If true, billing number
        #     and address fields are not needed.
        #   - *billing_number* [String] - Billing number.
        #   - *billing_address1* [String] - Billing address line 1
        #   - *billing_address2* [String] - Billing address line 2
        #   - *billing_city* [String] - Billing address city.
        #   - *billing_state* [String] - Billing address state.
        #   - *billing_zip* [String] - Billing address zip.
        # @return [Phaxio::Resources::PortOrder]
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/port_orders/create_port_order
        def create params = {}
          response = Client.request :post, port_orders_endpoint, params
          response_record response
        end

        # Get port order info.
        # @param id [Integer]
        #   The ID of the order to retrieve.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio. This action takes no unique parameters.
        # @return [Phaxio::Resource::PortOrder]
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/port_orders/get_port_order
        def get id, params = {}
          response = Client.request :get, port_order_endpoint(id.to_i), params
          response_record response
        end
        alias :retrieve :get
        alias :find :get

        private

        def port_orders_endpoint
          PORT_ORDERS_PATH
        end

        def port_order_endpoint id
          "#{PORT_ORDERS_PATH}/#{id}"
        end
      end
    end
  end
end
