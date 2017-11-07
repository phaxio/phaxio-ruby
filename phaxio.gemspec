# -*- encoding: utf-8 -*-
require File.expand_path('../lib/phaxio/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Julien Negrotto"]
  gem.email         = ["julien@phaxio.com"]
  gem.description   = %q{Official ruby gem for interacting with Phaxio's API.}
  gem.summary       = %q{Official ruby gem for interacting with Phaxio's API.}
  gem.homepage      = "https://github.com/phaxio/phaxio-ruby"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "phaxio"
  gem.require_paths = ["lib"]
  gem.version       = Phaxio::VERSION

  gem.add_dependency 'faraday', '~> 0.10'
  gem.add_dependency 'mime-types', '~> 3.0'
end
