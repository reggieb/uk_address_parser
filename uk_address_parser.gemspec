# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uk_address_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "uk_address_parser"
  spec.version       = UkAddressParser::VERSION
  spec.authors       = ["Rob Nichols"]
  spec.email         = ["rob@undervale.co.uk"]

  spec.summary       = %q{Tool to convert a UK address string into its constituent parts.}
  spec.homepage      = "https://github.com/reggieb/uk_address_parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "faker", "~> 1.6"
end
