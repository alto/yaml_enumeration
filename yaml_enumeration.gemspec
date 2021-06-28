# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yaml_enumeration/version'

Gem::Specification.new do |spec|
  spec.name          = "yaml_enumeration"
  spec.version       = YamlEnumeration::VERSION
  spec.authors       = ["Thorsten Boettger"]
  spec.email         = ["boettger@mt7.de"]

  spec.summary       = %q(Create ActiveRecord enumerations based on YAML files.)
  spec.description   = %q(Create classes which work like ActiveRecord classes,
                          but are defined as fixed enumerations based on YAML files.)
  spec.homepage      = "https://github.com/alto/yaml_enumeration"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "maxitest"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubocop", '1.17.0'
  spec.add_development_dependency "rubocop-performance", '1.11.3'
  spec.add_development_dependency "shoulda-context"

  spec.add_dependency "activesupport", '>= 6'
  spec.add_dependency "railties", '>= 6'
end
