# -*- encoding: utf-8 -*-
require File.expand_path('../lib/red25519/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tony Arcieri"]
  gem.email         = ["tony.arcieri@gmail.com"]
  gem.description   = "Ruby wrappers for the Ed25519 public key signature system"
  gem.summary       = "Red25519 provides both C and Java bindings to the Ed25519 public key signature system"
  gem.homepage      = "https://github.com/tarcieri/red25519"

  gem.files = `git ls-files`.split($\)
  gem.files << "lib/red25519_engine.jar" if defined? JRUBY_VERSION

  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "red25519"
  gem.require_paths = ["lib"]
  gem.version       = Ed25519::VERSION

  if defined? JRUBY_VERSION
    gem.platform = "jruby"
  else
    gem.extensions = "ext/red25519/extconf.rb"
  end

  gem.add_runtime_dependency "hkdf"

  gem.add_development_dependency "rake-compiler"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
end
