# frozen_string_literal: true

if defined?(JRUBY_VERSION)
  RSpec.describe Ed25519::Provider::JRuby do
    include_examples "Ed25519::Provider"
  end
end
