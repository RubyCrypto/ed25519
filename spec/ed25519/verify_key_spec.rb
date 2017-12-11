# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ed25519::VerifyKey do
  let(:signing_key) { Ed25519::SigningKey.generate }
  let(:verify_key)  { signing_key.verify_key }
  let(:message)     { "example message" }

  it "verifies messages" do
    signature = signing_key.sign(message)
    expect(verify_key.verify(signature, message)).to be_truthy

    bad_signature = signature[0...63] + "X"
    expect(verify_key.verify(bad_signature, message)).to be_falsey
  end

  it "serializes to bytes" do
    bytes = verify_key.to_bytes
    expect(bytes).to be_a String
    expect(bytes.length).to eq 32
  end
end
