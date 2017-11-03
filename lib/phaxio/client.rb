module Phaxio
  # @api private
  class Client
    BASE_URL = 'https://api.phaxio.com/v2/'

    class << self
      # Makes a request to the Phaxio API.
      #
      # @param method [Symbol, String]
      #   The HTTP method for the request. Currently only `:get`, `:post`, and `:delete` are
      #   supported.
      # @param endpoint [String]
      #   The endpoint for the API action, relative to `BASE_URL`.
      # @param params [Hash]
      #   Any request-specific parameters.
      # @param options [Hash]
      #   Additional parameters, such as overrides for `:api_key` and `:api_secret`
      #
      # @return [Object]
      #   The `"data"` attribute of the deserialized JSON response. Varies based on the API action.
      def request method, endpoint, params = {}, options = {}
        params = api_params params, options
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

      # @return [Faraday::Connection] A new Faraday connection to `BASE_URL`.
      def conn
        Faraday.new(BASE_URL) do |conn|
          conn.request :multipart
          conn.request :url_encoded
          conn.adapter :net_http
        end
      end

      private

      def handle_response response
        content_type = response.headers[:content_type]

        if content_type.start_with? 'application/json'
          body = JSON.parse response.body
        else
          body = {'success' => response.success?, 'data' => StringIO.new(response.body)}
        end

        if response.success?
          raise(Error::GeneralError, body['message']) unless body['success']

          body['data']
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

      def post endpoint, params = {}
        # Handle file params
        params.each do |k, v|
          # Convert file params to a Faraday::UploadIO object
          # TODO: Support passing in the file path as a string
          next unless k.to_s == 'file'
          mime_type = MimeTypeHelper.mimetype_for_file v.path
          params[k] = Faraday::UploadIO.new v, mime_type
        end

        conn.post endpoint, params
      end

      def get endpoint, params = {}
        conn.get endpoint, params
      end

      def delete endpoint, params = {}
        conn.delete endpoint, params
      end

      def api_params params, options
        params = params.merge(default_params).merge(options)

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
    end
  end
end
