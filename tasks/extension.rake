# frozen_string_literal: true

if defined? JRUBY_VERSION
  require "rake/javaextensiontask"
  Rake::JavaExtensionTask.new("ed25519_engine") do |ext|
    ext.ext_dir = "ext/ed25519"
  end
else
  require "rake/extensiontask"

  Rake::ExtensionTask.new("ed25519_engine") do |ext|
    ext.ext_dir = "ext/ed25519"
  end
end
