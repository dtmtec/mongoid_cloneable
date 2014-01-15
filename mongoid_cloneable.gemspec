# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid/cloneable/version'

Gem::Specification.new do |gem|
  gem.name          = "mongoid_cloneable"
  gem.version       = Mongoid::Cloneable::VERSION
  gem.authors       = ["Vicente Mundim"]
  gem.email         = ["vicente.mundim@gmail.com"]
  gem.description   = %q{Provides improved cloning features for Mongoid}
  gem.summary       = %q{Provides improved cloning features for Mongoid}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("activesupport", [">= 3.2"])
  gem.add_dependency("mongoid", [">= 3.1"])
end
