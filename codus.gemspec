# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'codus/version'

Gem::Specification.new do |spec|
  spec.name          = "codus"
  spec.version       = Codus::VERSION
  spec.authors       = ["Vinícius Oyama"]
  spec.email         = ["vinicius.oyama@gmail.com"]
  spec.description   = %q{Organize your javascript across namespaces matching your controllers and actions. Get automatic executing functions for current controller and action.}
  spec.summary       = %q{Organize your javascript across namespaces matching your controllers and actions. Get automatic executing functions for current controller and action.}
  spec.summary       = ""
  spec.license       = "MIT"

  spec.files         = Dir["{lib,vendor}/**/*"] + ["README.md"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "railties", "~> 3.1"
end
