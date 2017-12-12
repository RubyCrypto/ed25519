# frozen_string_literal: true

require "ed25519/version"
require "ed25519_engine"
require "ed25519/jruby_engine" if defined? JRUBY_VERSION
require "ed25519/signing_key"
require "ed25519/verify_key"

# The Ed25519 digital signatre algorithm
# rubocop:disable Metrics/LineLength
module Ed25519
  module_function

  # Size of an Ed25519 key (public or private) in bytes
  KEY_SIZE = 32

  # Size of an Ed25519 signature in bytes
  SIGNATURE_SIZE = 64

  # Raised when a signature fails to verify
  VerifyError = Class.new(StandardError)

  # Raised when the built-in self-test fails
  SelfTestFailure = Class.new(StandardError)

  # Perform a self-test to ensure the selected provider is working
  def self_test
    signature_key = Ed25519::SigningKey.new("A" * 32)
    raise SelfTestFailure, "failed to generate verify key correctly" unless signature_key.verify_key.to_bytes.unpack("H*").first == "db995fe25169d141cab9bbba92baa01f9f2e1ece7df4cb2ac05190f37fcc1f9d"

    message = "crypto libraries should self-test on boot"
    signature = signature_key.sign(message)
    raise SelfTestFailure, "failed to generate correct signature" unless signature.unpack("H*").first == "c62c12a3a6cbfa04800d4be81468ef8aecd152a6a26a81d91257baecef13ba209531fe905a843e833c8b71cee04400fa2af3a29fef1152ece470421848758d0a"

    verify_key = signature_key.verify_key
    raise SelfTestFailure, "failed to verify a valid signature" unless verify_key.verify(signature, message)

    bad_signature = signature[0...63] + "X"
    ex = nil

    # rubocop:disable Lint/HandleExceptions
    begin
      verify_key.verify(bad_signature, message)
    rescue Ed25519::VerifyError => ex
    end
    # rubocop:enable Lint/HandleExceptions

    raise SelfTestFailure, "failed to detect an invalid signature" unless ex.is_a?(Ed25519::VerifyError)
  end
end

# Automatically run self-test when library loads
Ed25519.self_test
