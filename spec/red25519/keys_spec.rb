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
end
