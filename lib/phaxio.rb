require 'json'
require 'tempfile'
require 'openssl'
require 'time'
require 'faraday'
require 'active_support/core_ext/hash/indifferent_access'
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

  class << self
    # @!attribute api_key
    #   @see Config.api_key
    # @!attribute api_secret
    #   @see Config.api_secret
    # @!attribute callback_token
    #   @see Config.callback_token
    # @!attribute api_endpoint
    #   @see Config.api_endpoint
    %w(api_key api_secret callback_token api_endpoint).each do |config_attribute|
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
