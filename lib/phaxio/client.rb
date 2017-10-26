module Phaxio
  class Client
    BASE_URL = 'https://api.phaxio.com/v2/'

    class << self
      def request method, endpoint, params = {}, options = {}
        url = api_url endpoint
        params = api_params params, options
        RestClient.public_send method, url, params
      end

      private

      def api_url endpoint
        raise "API endpoint can't begin with a slash" if endpoint.start_with?('/')
        URI.join(BASE_URL, endpoint).to_s
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
