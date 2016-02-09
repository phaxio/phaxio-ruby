# -*- encoding: utf-8 -*-
require File.expand_path('../lib/phaxio/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sean Behan", "Brett Chalupa"]
  gem.email         = ["inbox@seanbehan.com", "brettchalupa@gmail.com"]
  gem.description   = %q{A Ruby Gem for interacting with Phaxio's JSON API. Currently, not all of the Phaxio API calls are supported. The essentials are in place and more will be coming with future versions of this gem.}
  gem.summary       = %q{A Ruby Gem for interacting with Phaxio's JSON API}
  gem.homepage      = "http://www.gristmill.io/posts/17-introducing-the-phaxio-gem-an-easy-way-to-use-phaxio-with-ruby"

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
