# frozen_string_literal: true

unless defined?(JRUBY_VERSION)
  RSpec.describe Ed25519::Provider::Ref10 do
    include_examples "Ed25519::Provider"
  end
end
