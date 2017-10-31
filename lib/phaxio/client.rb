module Phaxio
  class Client
    BASE_URL = 'https://api.phaxio.com/v2/'

    class << self
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

      def conn
        Faraday.new(BASE_URL) do |conn|
          conn.request :multipart
          conn.request :url_encoded
          conn.adapter :net_http
        end
      end

      private

      def handle_response response
        # TODO: Handle JSON parse error
        body = JSON.parse response.body

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
          mime_type = File.mime_type? v # This does not return a boolean value
          params[k] = Faraday::UploadIO.new(v, mime_type)
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
