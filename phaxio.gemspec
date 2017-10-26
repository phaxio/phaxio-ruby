# -*- encoding: utf-8 -*-
require File.expand_path('../lib/phaxio/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sean Behan", "Brett Chalupa"]
  gem.email         = ["inbox@seanbehan.com", "brettchalupa@gmail.com"]
  gem.description   = %q{Official ruby gem for interacting with Phaxio's API.}
  gem.summary       = %q{Official ruby gem for interacting with Phaxio's API.}
  gem.homepage      = "https://github.com/phaxio/phaxio-ruby"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "phaxio"
  gem.require_paths = ["lib"]
  gem.version       = Phaxio::VERSION

  gem.add_runtime_dependency 'rest-client', '>= 2.0'

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rake', '~> 10'
  gem.add_development_dependency 'rspec', '~> 3.7'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'dotenv'
end
