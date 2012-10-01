require 'spec_helper'

describe Ed25519::Engine do
  let(:seed_length) { Ed25519::SECRET_KEY_BYTES / 2 }

  it "generates keypairs" do
    ary = Ed25519::Engine.create_keypair("A" * seed_length)

    ary.length.should eq 2
    pubkey, privkey = ary

    pubkey.should be_a String
    pubkey.length.should eq Ed25519::PUBLIC_KEY_BYTES

    privkey.should be_a String
    privkey.length.should eq Ed25519::SECRET_KEY_BYTES
  end

  it "raises ArgumentError if the seed is not #{Ed25519::SECRET_KEY_BYTES / 2} bytes long" do
    expect { Ed25519::Engine.create_keypair("A" * (seed_length - 1)) }.to raise_exception ArgumentError
    expect { Ed25519::Engine.create_keypair("A" * (seed_length + 1)) }.to raise_exception ArgumentError
  end
end
