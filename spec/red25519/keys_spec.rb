require 'spec_helper'

describe Ed25519::SigningKey do
  let(:key) { Ed25519::SigningKey.generate }
  let(:message) { "example message" }

  it "generates keypairs" do

    key.should be_a Ed25519::SigningKey
    key.verify_key.should be_a Ed25519::VerifyKey
  end

  it "signs messages" do
    key.sign(message).should be_a String
  end
end

describe Ed25519::VerifyKey do
  let(:signing_key) { Ed25519::SigningKey.generate }
  let(:verify_key)  { signing_key.verify_key }
  let(:message)     { "example message" }

  it "verifies messages" do
    signature = signing_key.sign(message)
    verify_key.verify(signature, message).should be_true

    bad_signature = signature[0...63] + "X"
    verify_key.verify(bad_signature, message).should be_false
  end
end
