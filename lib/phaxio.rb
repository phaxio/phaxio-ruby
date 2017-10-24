require 'forwardable'

require 'phaxio/version'
require 'phaxio/config'

module Phaxio
  # `#define_method` defines an instance method, so to define a class method
  # with it we need to open up `Phaxio`s eigenclass.
  class << self
    %w(api_key api_secret callback_token).each do |config_attribute|
      # Define getters
      define_method(config_attribute) do
        Config.public_send config_attribute
      end

      # Define setters
      setter = "#{config_attribute}="
      define_method(setter) do |value|
        Config.public_send setter, value
      end
    end
  end
end
