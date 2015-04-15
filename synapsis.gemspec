# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'synapsis/version'

Gem::Specification.new do |spec|
  spec.name          = "synapsis"
  spec.version       = Synapsis::VERSION
  spec.authors       = ["Daryll Santos"]
  spec.email         = ["daryll.santos@gmail.com"]
  spec.summary       = %q{Ruby wrapper to the SynapsePay API}
  spec.description   = %q{Ruby wrapper to the SynapsePay API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday", "0.9.1"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
