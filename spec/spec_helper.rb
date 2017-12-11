require 'bundler'
Bundler.require :default, :development, :test
require File.expand_path(File.join(['..', '..', 'lib', 'phaxio']), __FILE__)
Dir[File.expand_path(File.join(['..', 'support', '**', '*.rb']), __FILE__)].each { |file| require file }

include Phaxio::Resources
