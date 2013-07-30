# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'codus/version'

Gem::Specification.new do |spec|
  spec.name          = "codus"
  spec.version       = Codus::VERSION.freeze
  spec.authors       = ["Vinícius Oyama"]
  spec.email         = ["vinicius.oyama@gmail.com"]
  spec.description   = %q{Organize your javascript across namespaces matching your controllers and actions. Get automatic executing functions for current controller and action.}
  spec.summary       = %q{Organize your javascript across namespaces matching your controllers and actions. Get automatic executing functions for current controller and action.}
  spec.authors       = ['Vinícius Oyama']
  spec.email         = "vinicius.oyama@codus.com.br"
  spec.homepage      = "https://github.com/codus/codus"
  spec.license       = "MIT"

  # normal spec stuff above
  spec.files = `git ls-files`.split("\n")
 
  # get an array of submodule dirs by executing 'pwd' inside each submodule
  gem_dir = File.expand_path(File.dirname(__FILE__)) + "/"
  `git submodule --quiet foreach pwd`.split($\).each do |submodule_path|
    Dir.chdir(submodule_path) do
      submodule_relative_path = submodule_path.sub gem_dir, ""
      # issue git ls-files in submodule's directory and
      # prepend the submodule path to create absolute file paths
      `git ls-files`.split($\).each do |filename|
        spec.files << "#{submodule_relative_path}/#{filename}"
      end
    end
  end

  spec.executables  = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "railties", "~> 3.1"
end
