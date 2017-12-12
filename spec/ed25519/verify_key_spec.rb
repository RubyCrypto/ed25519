# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ed25519::VerifyKey do
  let(:signing_key) { Ed25519::SigningKey.generate }
  let(:verify_key)  { signing_key.verify_key }
  let(:message)     { "example message" }
  let(:signature)   { signing_key.sign(message) }

  it "verifies messages with good signatures" do
    expect(verify_key.verify(signature, message)).to eq true
  end

  it "raises Ed25519::VerifyError on bad signatures" do
    bad_signature = signature[0...63] + "X"
    expect { verify_key.verify(bad_signature, message) }.to raise_error(Ed25519::VerifyError)
  end

  it "serializes to bytes" do
    bytes = verify_key.to_bytes
    expect(bytes).to be_a String
    expect(bytes.length).to eq Ed25519::KEY_SIZE
  end
end
