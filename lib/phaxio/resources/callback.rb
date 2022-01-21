module Phaxio
  module Resources
    # This class is provided for the sake of backwards compatibility; use the Webhook resource instead.
    # @see Phaxio::Resources::Webhook
    class Callback
      class << self
        def valid_signature? *args
          Phaxio::Resources::Webhook.valid_signature? *args
        rescue Error::PhaxioError => error
          if error.message == 'No webhook token has been set'
            raise Error::PhaxioError, 'No callback token has been set'
          else
            raise error
          end
        end
      end
    end
  end
end
