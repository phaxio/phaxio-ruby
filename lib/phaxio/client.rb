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
                     else raise Error::ArgumentError, "HTTP method `#{method}` is not supported."
                     end
          handle_response response
        rescue Faraday::ConnectionFailed, Faraday::TimeoutError, Faraday::SSLError => error
          raise Error::ApiConnectionError, "Error communicating with Phaxio: #{error}"
        end
      end

      def conn
        Faraday.new BASE_URL
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
        conn.post endpoint, params
      end

      def get endpoint, params = {}
        conn.get endpoint, params
      end

      def api_params params, options
        params.merge(default_params).merge(options)
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
