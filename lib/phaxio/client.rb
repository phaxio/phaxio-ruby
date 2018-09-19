# @!macro [new] paging
#   @note
#     This action accepts paging parameters:
#     - *per_page* [Integer] - The maximum number of results to return per
#       call (i.e. "page"). Max 1000.
#     - *page* [Integer] - The page number to return for the request. 1-based.

module Phaxio
  # @api private

  class Client
    class << self
      # Makes a request to the Phaxio API.
      #
      # @param method [Symbol, String]
      #   The HTTP method for the request. Currently only `:get`, `:post`, and `:delete` are
      #   supported.
      # @param endpoint [String]
      #   The endpoint for the API action, relative to `Phaxio::Config.api_endpoint`.
      # @param params [Hash]
      #   Any parameters to be sent with the request.
      #
      # @return [Object]
      #   The `"data"` attribute of the deserialized JSON response. Varies based on the API action.
      def request method, endpoint, params = {}
        params = api_params params
        begin
          response = case method.to_s
                     when 'post' then post(endpoint, params)
                     when 'get' then get(endpoint, params)
                     when 'delete' then delete(endpoint, params)
                     else raise ArgumentError, "HTTP method `#{method}` is not supported."
                     end
          handle_response response
        rescue Faraday::ConnectionFailed, Faraday::TimeoutError, Faraday::SSLError => error
          raise Error::ApiConnectionError, "Error communicating with Phaxio: #{error}"
        end
      end

      # @return [Faraday::Connection] A new Faraday connection to `Phaxio::Config.api_endpoint`.
      def conn
        Faraday.new(Phaxio.api_endpoint) do |conn|
          conn.request :multipart
          conn.request :url_encoded
          conn.adapter :net_http
        end
      end

      private

      def handle_response response
        content_type = response.headers[:content_type]

        if content_type.start_with? 'application/json'
          body = JSON.parse(response.body).with_indifferent_access
        else
          extension = MimeTypeHelper.extension_for_mimetype content_type
          filename = File.join Dir.tmpdir, tmpname(extension)
          File.open(filename, 'wb') { |file| file.write response.body }
          body = {'success' => response.success?, 'data' => File.open(filename, 'rb')}
        end

        if response.success?
          raise(Error::GeneralError, body['message']) unless body['success']

          # Check if this is a response with paging. If so, we want to return that along with the
          # data.
          if body.key? 'paging'
            {'data' => body['data'], 'paging' => body['paging']}
          else
            body['data']
          end
        else
          status = response.status
          # TODO: Handle blank message
          message = body['message']

          case status
          when 401
            raise Error::AuthenticationError, "#{status}: #{message}"
          when 404
            raise Error::NotFoundError, "#{status}: #{message}"
          when 422
            raise Error::InvalidRequestError, "#{status}: #{message}"
          when 429
            raise Error::RateLimitExceededError, "#{status}: #{message}"
          else
            raise Error::GeneralError, "#{status}: #{message}"
          end
        end
      end

      def tmpname(extension)
        t = Time.now.strftime("%Y%m%d")
        "phaxio-#{t}-#{$$}-#{rand(0x100000000).to_s(36)}-download.#{extension}"
      end

      def post endpoint, params = {}
        # Handle file params
        params.each do |k, v|
          next unless k.to_s == 'file'

          if v.is_a? Array
            file_param = v.map { |file| file_to_param file }
          else
            file_param = file_to_param v
          end

          params[k] = file_param
        end

        conn.post endpoint, params
      end

      def get endpoint, params = {}
        conn.get endpoint, params
      end

      def delete endpoint, params = {}
        conn.delete endpoint, params
      end

      def api_params params
        params = default_params.merge params

        # Convert times to ISO 8601
        params.each do |k, v|
          next unless v.kind_of?(Time) || v.kind_of?(Date)
          params[k] = v.to_datetime.iso8601
        end

        params
      end

      def default_params
        {
          api_key: Phaxio.api_key,
          api_secret: Phaxio.api_secret
        }
      end

      def file_to_param file
        mime_type = MimeTypeHelper.mimetype_for_file file.path
        Faraday::UploadIO.new file, mime_type
      end
    end
  end
end
