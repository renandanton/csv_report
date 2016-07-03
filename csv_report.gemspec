# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'csv_report/version'

Gem::Specification.new do |spec|
  spec.name          = "csv_report"
  spec.version       = CsvReport::VERSION
  spec.authors       = ["Renan Danton"]
  spec.email         = ["renandanton@yahoo.com.br"]

  spec.summary       = %q{Generate a simple report in console.}
  spec.description   = %q{Generate report for a csv file entry.}
  spec.homepage      = "https://github.com/renandanton/csv_report"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.1.8'

  spec.add_dependency "chronic_duration", "~> 0.10.6"
  spec.add_dependency "bytes_converter",  "~> 0.0.5"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
end
