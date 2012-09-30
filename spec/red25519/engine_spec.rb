require 'spec_helper'

describe Ed25519::Engine do
  it "generates signing keys" do
    Ed25519::Engine.create_signing_key
  end
end