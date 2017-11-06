module Phaxio
  module Resources
    class Callback
      DIGEST = OpenSSL::Digest.new('sha1')

      class << self
        def valid_signature? signature, url, params, files = []
          check_signature = generate_check_signature url, params, files
          check_signature == signature
        end

        def generate_check_signature url, params, files = []
          params_string = generate_params_string(params)
          files_string = generate_files_string(files)
          callback_data = "#{url}#{params_string}#{files_string}"
          OpenSSL::HMAC.hexdigest(DIGEST, callback_token, callback_data)
        end

        private

        def callback_token
          Phaxio.callback_token or raise(Error::PhaxioError, 'No callback token has been set')
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
  end
end
