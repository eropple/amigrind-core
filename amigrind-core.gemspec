# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'amigrind/core/version'

Gem::Specification.new do |spec|
  spec.name          = "amigrind-core"
  spec.version       = Amigrind::Core::VERSION
  spec.authors       = ["Ed Ropple"]
  spec.email         = ["ed@edropple.com"]

  spec.summary       = "Core logic for Amigrind."
  spec.homepage      = "https://github.com/eropple/amigrind"
  spec.license       = "Apache 2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_runtime_dependency "pry"

  spec.add_runtime_dependency 'ice_nine', '~> 0.11.2'
  spec.add_runtime_dependency 'aws-sdk', '~> 2.2.31'
end
