require 'yaml' # Needed by Mimetype Fu
require 'json'
require 'tempfile'
require 'openssl'
require 'faraday'
require 'mime/types/full'
require 'phaxio/version'
require 'phaxio/config'
require 'phaxio/client'
require 'phaxio/error'
require 'phaxio/resource'
require 'phaxio/resources'

Dir[File.expand_path(File.join('..', 'phaxio', 'helpers', '*.rb'), __FILE__)].each do |file|
  require file
end

%w[fax_recipient country fax account area_code callback phax_code phone_number].each do |filename|
  require File.expand_path(File.join('..', 'phaxio', 'resources', filename), __FILE__)
end

module Phaxio
  include Resources

  # `#define_method` defines an instance method, so to define a class method
  # with it we need to open up `Phaxio`s eigenclass.
  class << self
    # @!attribute api_key
    #   @see Config.api_key
    # @!attribute api_secret
    #   @see Config.api_secret
    # @!attribute callback_token
    #   @see Config.callback_token
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
