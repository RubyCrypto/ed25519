# frozen_string_literal: true

RSpec.shared_examples "Ed25519::Provider" do
  let(:seed_length) { Ed25519::KEY_SIZE }
  let(:message)     { "foobar" }

  it "generates keypairs" do
    ary = described_class.create_keypair("A" * seed_length)

    expect(ary.length).to eq 2
    pubkey, privkey = ary

    expect(pubkey).to be_a String
    expect(pubkey.length).to eq Ed25519::KEY_SIZE

    expect(privkey).to be_a String
    expect(privkey.length).to eq Ed25519::KEY_SIZE * 2
  end

  it "raises ArgumentError if the seed is not #{Ed25519::KEY_SIZE} bytes long" do
    expect { described_class.create_keypair("A" * (seed_length - 1)) }.to raise_exception ArgumentError
    expect { described_class.create_keypair("A" * (seed_length + 1)) }.to raise_exception ArgumentError
  end

  it "signs and verifies messages" do
    verify_key, signing_key = described_class.create_keypair("A" * seed_length)
    signature = described_class.sign(signing_key, message)
    expect(described_class.verify(verify_key, signature, message)).to be_truthy

    bad_signature = signature[0...63] + "X"
    expect(described_class.verify(verify_key, bad_signature, message)).to be_falsey
  end
end
