module Phaxio
  module Resources
    # Provides utilities for working with callbacks.
    # @see https://www.phaxio.com/docs/api/v2.1/faxes/send_webhook
    # @see https://www.phaxio.com/docs/api/v2.1/faxes/receive_webhooks
    class Webhook
      DIGEST = OpenSSL::Digest.new('sha1')
      private_constant :DIGEST

      class << self
        # Determines whether or not the passed signature is valid for the given
        # url, params, and files.
        # @param signature [String]
        #   The signature received from Phaxio.
        # @param url [String]
        #   The webhook URL used in this request.
        # @param params [Hash]
        #   The parameters received with the webhook, excluding files.
        # @param files [Array<File>]
        #   The files received with the webhook, if any.
        # @return [true, false]
        # @raise [Phaxio::Error::PhaxioError]
        # @see https://www.phaxio.com/docs/security/callbacks
        def valid_signature? signature, url, params, files = []
          check_signature = generate_check_signature url, params, files
          check_signature == signature
        end

        private

        def generate_check_signature url, params, files = []
          params_string = generate_params_string(params)
          files_string = generate_files_string(files)
          webhook_data = "#{url}#{params_string}#{files_string}"
          OpenSSL::HMAC.hexdigest(DIGEST, webhook_token, webhook_data)
        end

        def webhook_token
          Phaxio.webhook_token or raise(Error::PhaxioError, 'No webhook token has been set')
        end

        def generate_params_string(params)
          sorted_params = params.sort_by { |key, _value| key }
          params_strings = sorted_params.map { |key, value| "#{key}#{value}" }
          params_strings.join
        end

        def generate_files_string(files)
          files_array = files_to_array(files).reject(&:nil?)
          sorted_files = files_array.sort_by { |file| file[:name] }
          files_strings = sorted_files.map { |file| generate_file_string(file) }
          files_strings.join
        end

        def files_to_array(files)
          files.is_a?(Array) ? files : [files]
        end

        def generate_file_string(file)
          file[:name] + DIGEST.hexdigest(file[:tempfile].read)
        end
      end
    end

    # for backwards compatibility
    Callback = Webhook
  end
end
