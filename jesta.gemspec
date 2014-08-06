# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jesta/version'

Gem::Specification.new do |spec|
  spec.name          = "jesta"
  spec.version       = Jesta::VERSION
  spec.authors       = ["Kenta Tada"]
  spec.email         = ["ktagml@gmail.com"]
  spec.summary       = %q{Virtual Machine Image Exporter}
  spec.description   = %q{Jesta is a tool to export Virtual Machine Image with some useful options.}

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk"
  spec.add_dependency "net-ssh"
  spec.add_dependency "net-scp"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
