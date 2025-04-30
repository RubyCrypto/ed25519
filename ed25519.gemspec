# frozen_string_literal: true

require File.expand_path("lib/ed25519/version", __dir__)

Gem::Specification.new do |spec|
  spec.name          = "ed25519"
  spec.version       = Ed25519::VERSION
  spec.authors       = ["Tony Arcieri"]
  spec.email         = ["tony.arcieri@gmail.com"]
  spec.summary       = "An efficient digital signature library providing the Ed25519 algorithm"
  spec.description = <<-DESCRIPTION.strip.gsub(/\s+/, " ")
    A Ruby binding to the Ed25519 elliptic curve public-key signature system
    described in RFC 8032.
  DESCRIPTION
  spec.homepage      = "https://github.com/RubyCrypto/ed25519"
  spec.license       = "MIT"
  spec.files         = Dir["{ext,lib}/**/*", "CHANGES.md", "LICENSE"]
  spec.bindir        = "exe"
  spec.require_paths = ["lib"]
  spec.extra_rdoc_files = ["README.md", "ed25519.png"]

  if defined? JRUBY_VERSION
    spec.platform = "java"
    spec.files << "lib/ed25519_jruby.jar"
  else
    spec.platform   = Gem::Platform::RUBY
    spec.extensions = ["ext/ed25519_ref10/extconf.rb"]
  end

  spec.required_ruby_version = ">= 3.0"
  spec.add_development_dependency "bundler"
end
