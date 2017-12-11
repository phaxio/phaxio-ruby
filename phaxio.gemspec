# -*- encoding: utf-8 -*-
require File.expand_path('../lib/phaxio/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Josh Nankin"]
  gem.email         = ["support@phaxio.com"]
  gem.description   = %q{Ruby wrapper for the Phaxio API}
  gem.summary       = %q{Ruby wrapper for the Phaxio API}
  gem.homepage      = "http://github.com/phaxio/phaxio-ruby"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "phaxio"
  gem.require_paths = ["lib"]
  gem.version       = Phaxio::VERSION

  gem.add_runtime_dependency "httmultiparty"

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'fakeweb', '~> 1.3'
  gem.add_development_dependency 'rake', '~> 10'
  gem.add_development_dependency 'minitest', '~> 5'
  gem.add_development_dependency 'mocha', '~> 1.1'
end
