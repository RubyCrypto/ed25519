# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ed25519::Engine do
  let(:seed_length) { Ed25519::KEY_SIZE }
  let(:message)     { "foobar" }

  it "generates keypairs" do
    ary = Ed25519::Engine.create_keypair("A" * seed_length)

    expect(ary.length).to eq 2
    pubkey, privkey = ary

    expect(pubkey).to be_a String
    expect(pubkey.length).to eq Ed25519::KEY_SIZE

    expect(privkey).to be_a String
    expect(privkey.length).to eq Ed25519::KEY_SIZE * 2
  end

  it "raises ArgumentError if the seed is not #{Ed25519::KEY_SIZE} bytes long" do
    expect { Ed25519::Engine.create_keypair("A" * (seed_length - 1)) }.to raise_exception ArgumentError
    expect { Ed25519::Engine.create_keypair("A" * (seed_length + 1)) }.to raise_exception ArgumentError
  end

  it "signs and verifies messages" do
    verify_key, signing_key = Ed25519::Engine.create_keypair("A" * seed_length)
    signature = Ed25519::Engine.sign(signing_key, message)
    expect(Ed25519::Engine.verify(verify_key, signature, message)).to be_truthy

    bad_signature = signature[0...63] + "X"
    expect(Ed25519::Engine.verify(verify_key, bad_signature, message)).to be_falsey
  end
end
