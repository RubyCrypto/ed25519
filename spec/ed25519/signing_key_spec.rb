# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ed25519::SigningKey do
  let(:key) { Ed25519::SigningKey.generate }
  let(:message) { "example message" }

  it "generates keypairs" do
    expect(key).to be_a Ed25519::SigningKey
    expect(key.verify_key).to be_a Ed25519::VerifyKey
  end

  it "signs messages" do
    expect(key.sign(message)).to be_a String
  end

  it "serializes to bytes" do
    bytes = key.to_bytes
    expect(bytes).to be_a String
    expect(bytes.length).to eq 32
  end
end
