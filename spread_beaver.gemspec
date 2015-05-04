# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spread_beaver/version'

Gem::Specification.new do |spec|
  spec.name          = "spread_beaver"
  spec.version       = SpreadBeaver::VERSION
  spec.authors       = ["shinya takahashi"]
  spec.email         = ["s.takahashi313@gmail.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_dependency "connection_pool"
  spec.add_dependency "execjs"
  spec.add_dependency "request_store"
  spec.add_dependency "rails", ">= 4.2"
end
