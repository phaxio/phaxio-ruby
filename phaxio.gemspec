# -*- encoding: utf-8 -*-
require File.expand_path('../lib/phaxio/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sean Behan", "Brett Chalupa"]
  gem.email         = ["inbox@seanbehan.com", "brettchalupa@gmail.com"]
  gem.description   = %q{A Ruby Gem for interacting with Phaxio's JSON API}
  gem.summary       = %q{A Ruby Gem for interacting with Phaxio's JSON API}
  gem.homepage      = "http://gristmill.io"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "phaxio"
  gem.require_paths = ["lib"]
  gem.version       = Phaxio::VERSION

  gem.add_runtime_dependency      "httmultiparty"
  gem.add_development_dependency  "fakeweb",    "~> 1.3.0"
  gem.add_development_dependency  "rake",       "~> 0.9.2.2"
end
