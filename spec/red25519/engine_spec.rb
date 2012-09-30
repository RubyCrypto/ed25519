require 'spec_helper'

describe Ed25519::Engine do
  it "generates keypairs" do
    Ed25519::Engine.create_keypair("foobar")
  end
end