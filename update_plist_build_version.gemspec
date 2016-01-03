# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'update_plist_build_version/version'

Gem::Specification.new do |spec|
  spec.name          = "update_plist_build_version"
  spec.version       = UpdatePlistBuildVersion::VERSION
  spec.authors       = ["Shin Hiroe"]
  spec.email         = ["hiroe.orz@gmail.com"]

  spec.description   = %q{Increment Version of info.plist}
  spec.summary       = %q{Increment Version of info.plist}
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = ['update_plist_build_version']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
