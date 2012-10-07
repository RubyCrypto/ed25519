require 'spec_helper'

describe Ed25519::Engine do
  let(:seed_length) { Ed25519::SECRET_KEY_BYTES }
  let(:message)     { 'foobar' }

  it "generates keypairs" do
    ary = Ed25519::Engine.create_keypair("A" * seed_length)

    ary.length.should eq 2
    pubkey, privkey = ary

    pubkey.should be_a String
    pubkey.length.should eq Ed25519::PUBLIC_KEY_BYTES

    privkey.should be_a String
    privkey.length.should eq Ed25519::SECRET_KEY_BYTES * 2
  end

  it "raises ArgumentError if the seed is not #{Ed25519::SECRET_KEY_BYTES / 2} bytes long" do
    expect { Ed25519::Engine.create_keypair("A" * (seed_length - 1)) }.to raise_exception ArgumentError
    expect { Ed25519::Engine.create_keypair("A" * (seed_length + 1)) }.to raise_exception ArgumentError
  end

  it "signs and verifies messages" do
    verify_key, signing_key = Ed25519::Engine.create_keypair("A" * seed_length)
    signature = Ed25519::Engine.sign(signing_key, message)
    Ed25519::Engine.verify(verify_key, signature, message).should be_true

    bad_signature = signature[0...63] + "X"
    Ed25519::Engine.verify(verify_key, bad_signature, message).should be_false
  end
end
