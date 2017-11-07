module Phaxio
  module Resources
    # Provides functionality for viewing and managing faxes.
    class Fax < Resource
      FAXES_PATH = 'faxes'.freeze
      SUPPORTED_COUNTRIES_PATH = 'public/countries'.freeze
      private_constant :FAXES_PATH, :SUPPORTED_COUNTRIES_PATH

      # @return [Integer] the ID associated with this fax.
      # @!attribute id

      # @return ["sent" | "received"] the direction of the fax.
      # @!attribute direction

      # @return [Integer] the number of pages in the fax.
      # @!attribute num_pages

      # @return [Integer] the cost of the fax in cents.
      # @!attribute cost

      # @return [String] the status of the fax.
      # @!attribute status

      # @return [true | false]
      #   an indication of whether or not this is a test fax.
      # @!attribute is_test

      # @return [String]
      #   for sent faxes only, the number set as the Caller ID when sending the
      #   fax.
      # @!attribute caller_id

      # @return [String]
      #   for received faxes only, the sender's E.164 phone number.
      # @!attribute from_number

      # @return [String]
      #   for received faxes only, the Phaxio phone number that was used to
      #   receive the call.
      # @!attribute to_number

      # @return [String]
      #   one of the Phaxio error types. Will give you a general idea of what
      #   went wrong for a failed fax.
      # @!attribute error_type

      # @return [String]
      #   a more detailed description of what went wrong for a failed fax.
      # @!attribute error_message

      # @return [Integer]
      #   a numeric error code that corresponds to the error message, if any.
      # @!attribute error_id

      # @return [Hash]
      #   a hash of tag name and value pairs. If a fax was sent with tag
      #   metadata, it will appear here.
      # @!attribute tags
      has_normal_attributes %w[
        id direction num_pages cost status is_test caller_id from_number
        to_number error_type error_message error_id tags
      ]

      # @return [Time]
      #   the time the fax was created.
      # @!attribute created_at

      # @return [Time]
      #   the time the fax was completed.
      # @!attribute completed_at

      has_time_attributes %w[created_at completed_at]

      # @return [Phaxio::Resource::Collection<Phaxio::Resources::FaxRecipient>]
      #   a collection of this fax's recipients.
      # @!attribute recipients

      has_collection_attributes({recipients: FaxRecipient})

      # A reference to a fax. This is returned by certain actions which don't
      # return the full fax.
      class Reference
        # @return [Integer]
        #   The ID of the fax being referenced.
        attr_accessor :id

        # Gets the referenced fax.
        # @return [Phaxio::Resource::Fax]
        #   The referenced Fax.
        def get
          Fax.get self
        end
        alias :retrieve :get
        alias :find :get

        def to_i
          id
        end

        private

        def initialize id
          self.id = id
        end
      end

      class << self
        # @macro paging
        # List faxes in date range.
        # @param params [Hash]
        #   Any parameters to send to Phaxio.
        #   - *direction* [String] - Either "sent" or "received". Limits results
        #     to faxes with the specified direction.
        #   - *status* [String] - Limits results to faxes with the specified
        #     status.
        #   - *phone_number* [String] - A phone number in E.164 format that you
        #     want to use to filter results. The phone number must be an exact
        #     match, not a number fragment.
        #   - *tag* [Hash<String: String>] - A tag name and value that you want
        #     to use to filter results.
        # @return [Phaxio::Resource::Collection<Phaxio::Resources::Fax>]
        #   The collection of faxes matching your request.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/faxes/list_faxes
        def list params = {}
          response = Client.request :get, faxes_endpoint, params
          response_collection response
        end

        # Create and send a fax.
        # @param params [Hash]
        #   Any parameters to send to Phaxio. At least one *to* number is
        #   required, as well as at least one *file* or *content_url*.
        #   - *to* [String | Array<String>] - One or more phone numbers in E.164
        #     format where this fax should be sent.
        #   - *file* [File | Array<File>] - The fax file(s) to be sent.
        #   - *content_url* [String, Array<String>] - URL(s) to be rendered and
        #     sent as the fax content. If the *file* param is included as well,
        #     URL content will come first in the transmitted files.
        #   - *header_text* [String] - Text that will be displayed at the top of
        #     each page of the fax. 50-character maximum. Defaults to "-".
        #   - *batch_delay* [Integer] - Enabled batching and specifies the
        #     amount of time, in seconds, before the batch is fired. Max is 3600
        #     (one hour).
        #   - *batch_collision_avoidance* [true | false] - When *batch_delay* is
        #     set, the fax will be blocked until the receiving machine is no
        #     longer busy.
        #   - *callback_url* [String] - You can specify a callback URL that will
        #     override one set globally in your account.
        #   - *cancel_timeout* [Integer] - Number of minutes after which the fax
        #     will be canceled if it hasn't yet completed. Must be between 3 and
        #     \60. Additionally, for faxes with *batch_delay* set, it must be at
        #     least 3 minutes after the *batch_delay*. If not, it will be
        #     automatically extended when batching.
        #   - *tag* [Hash<String: Object>] - A tag that contains metadata
        #     relevant to your application. For example, you may wish to tag a
        #     fax with an order id in your application. You could pass Phaxio
        #     the following parameter: +tag: {order_id: 1234}+. You may specify
        #     up to 10 tags.
        # @return [Phaxio::Resources::Fax]
        #   The created fax.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/faxes/create_and_send_fax
        # @see https://www.phaxio.com/docs/api/v2/faxes/batching
        def create params = {}
          response = Client.request :post, faxes_endpoint, params
          response_reference response
        end
        alias :send :create

        # Get fax info.
        # @param id [Integer]
        #   The ID of the fax to retrieve information about.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio. This action takes no unique parameters.
        # @return [Phaxio::Resource::Fax] The requested fax.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/faxes/get_fax
        def get id, params = {}
          response = Client.request :get, fax_endpoint(id.to_i), params
          response_record response
        end
        alias :retrieve :get
        alias :find :get

        # Cancel a fax.
        # @param id [Integer]
        #   The ID of the fax to cancel.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio. This action takes no unique
        #   parameters.
        # @return [Phaxio::Resources::Fax::Reference]
        #   A reference to the canceled fax.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/faxes/cancel
        def cancel id, params = {}
          response = Client.request :post, cancel_fax_endpoint(id), params
          response_reference response
        end

        # Resend a fax.
        # @param id [Integer]
        #   The ID of the fax to resend.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio.
        #   - *callback_url* [String] - This parameter may be used to set a
        #     different callback URL for the new fax.
        # @return [Phaxio::Resources::Fax::Reference]
        #   A reference to the resent fax.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/faxes/resend
        def resend id, params = {}
          response = Client.request :post, resend_fax_endpoint(id), params
          response_reference response
        end

        # Delete a fax. May only be used with test API credentials.
        # @param id [Integer]
        #   The ID of the fax to delete.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio. This action takes no unique
        #   parameters.
        # @return [true]
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/faxes/delete_fax
        def delete id, params = {}
          Client.request :delete, fax_endpoint(id), params
          true
        end

        # Delete fax files.
        # @param id [Integer]
        #   The ID of the fax for which you want to delete files.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio. This action takes no unique
        #   parameters.
        # @return [true]
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/faxes/delete_fax_file
        def delete_file id, params = {}
          Client.request :delete, fax_file_endpoint(id), params
          true
        end

        # Get fax content file or thumbnail.
        # @param id [Integer]
        #   The ID of the fax for which you want to get a file.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio.
        #   - *thumbnail* ["s" | "l"] - If set to +"s"+ (small) or +"l"+
        #     (large), a thumbnail of the requested size will be returned.
        #     If unset, returns a PDF of the fax image.
        # @return [File]
        #   The requested fax file.
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/faxes/get_fax_file
        def file id, params = {}
          Client.request :get, fax_file_endpoint(id), params
        end

        # Test receiving a fax. May only be used with test API credentials.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio.
        #   - *file* [File] - A PDF file to simulate receiving.
        #   - *from_number* [String] - The phone number of the simulated sender
        #     in E.164 format. Default is the public Phaxio phone number.
        #   - *to_number* [String] - The phone number, in E.164 format, that is
        #     receiving the fax. Specifically, a Phaxio phone number in your
        #     account that is "receiving" the fax, or the public Phaxio phone
        #     number. Default is the public Phaxio phone number.
        # @return [true]
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/api/v2/faxes/test_receive
        def test_receive params = {}
          Client.request :post, faxes_endpoint, test_receive_params(params)
          true
        end

        # @macro paging
        # Get a list of supported countries for sending faxes.
        # @param params [Hash]
        #   A hash of parameters to send to Phaxio. This action has no unique
        #   parameters.
        # @return [Phaxio::Resource::Collection<Phaxio::Resources::Country>]
        #   A collection of supported countries.
        # @raise Phaxio::Error::PhaxioError
        # @see https://www.phaxio.com/docs/api/v2/public/list_countries
        def supported_countries params = {}
          response = Client.request :get, supported_countries_endpoint, params
          Country.response_collection response
        end

        private

        def response_reference response
          Reference.new response['id']
        end

        def faxes_endpoint
          FAXES_PATH
        end

        def fax_endpoint id
          "#{FAXES_PATH}/#{id}"
        end

        def fax_file_endpoint id
          "#{fax_endpoint(id)}/file"
        end

        def cancel_fax_endpoint id
          "#{fax_endpoint(id)}/cancel"
        end

        def resend_fax_endpoint id
          "#{fax_endpoint(id)}/resend"
        end

        def supported_countries_endpoint
          SUPPORTED_COUNTRIES_PATH
        end

        def test_receive_params params
          {direction: 'received'}.merge(params)
        end
      end
    end
  end
end
