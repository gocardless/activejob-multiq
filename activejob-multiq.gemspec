# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activejob/multiq/version'

Gem::Specification.new do |spec|
  spec.name          = "activejob-multiq"
  spec.version       = ActiveJob::Multiq::VERSION
  spec.authors       = ["Isaac Seymour"]
  spec.email         = ["i.seymour@oxon.org"]
  spec.summary       = %q{Use different ActiveJob adapters for different jobs.}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/gocardless/activejob-multiq"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_dependency("activejob", "~> 4.2")
  spec.add_dependency("activesupport", "~> 4.2")

  spec.add_development_dependency("bundler", "~> 1.7")
  spec.add_development_dependency("rspec", "~> 3.1")
  spec.add_development_dependency("rspec-its", "~> 1.1")
  spec.add_development_dependency("que")
end
