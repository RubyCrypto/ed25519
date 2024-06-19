# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ed25519::SigningKey do
  let(:key) { described_class.generate }
  let(:message) { "example message" }

  describe ".generate" do
    it "generates keypairs" do
      expect(key).to be_a described_class
      expect(key.verify_key).to be_a Ed25519::VerifyKey
    end
  end

  describe ".from_keypair" do
    it "loads keypairs from bytes" do
      expect(described_class.from_keypair(key.keypair)).to be_a described_class
    end

    it "raises ArgumentError if given an invalid keypair" do
      expect { described_class.from_keypair("\0" * 64) }.to raise_error ArgumentError
    end
  end

  describe "#sign" do
    it "signs messages" do
      expect(key.sign(message)).to be_a String
    end
  end

  describe "#to_bytes" do
    it "serializes to bytes" do
      bytes = key.to_bytes
      expect(bytes).to be_a String
      expect(bytes.length).to eq Ed25519::KEY_SIZE
    end
  end

  describe "#to_pem" do
    it "serializes to a private key format that can be used by OpenSSL" do
      pem_formatted_key = key.to_pem
      expect(pem_formatted_key).to be_a String
      openssl_pkey = OpenSSL::PKey.read pem_formatted_key
      expect(openssl_pkey).to be_a OpenSSL::PKey::PKey
      expect(openssl_pkey.public_to_pem).to eq key.verify_key.to_pem
      expect(openssl_pkey.private_to_pem).to eq pem_formatted_key
      openssl_signature = openssl_pkey.sign(nil, message)
      expect(key.verify_key.verify(openssl_signature, message)).to be true
      expect { key.verify_key.verify(openssl_signature, "#{message}X") }.to raise_error(Ed25519::VerifyError)
    end
  end
end
