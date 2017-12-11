# frozen_string_literal: true

require "ed25519/version"
require "ed25519_engine"
require "ed25519/jruby_engine" if defined? JRUBY_VERSION
require "ed25519/signing_key"
require "ed25519/verify_key"

# The Ed25519 digital signatre algorithm
# rubocop:disable Metrics/LineLength
module Ed25519
  SECRET_KEY_BYTES = 32
  PUBLIC_KEY_BYTES = 32
  SIGNATURE_BYTES  = 64

  class SelfTestFailure < StandardError; end

  def self.test
    signature_key = Ed25519::SigningKey.new("A" * 32)
    raise SelfTestFailure, "failed to generate verify key correctly" unless signature_key.verify_key.to_bytes.unpack("H*").first == "db995fe25169d141cab9bbba92baa01f9f2e1ece7df4cb2ac05190f37fcc1f9d"

    message = "crypto libraries should self-test on boot"
    signature = signature_key.sign(message)
    raise SelfTestFailure, "failed to generate correct signature" unless signature.unpack("H*").first == "c62c12a3a6cbfa04800d4be81468ef8aecd152a6a26a81d91257baecef13ba209531fe905a843e833c8b71cee04400fa2af3a29fef1152ece470421848758d0a"

    verify_key = signature_key.verify_key
    raise SelfTestFailure, "failed to verify a valid signature" unless verify_key.verify(signature, message)

    bad_signature = signature[0...63] + "X"
    raise SelfTestFailure, "failed to detect an invalid signature" unless verify_key.verify(bad_signature, message) == false
  end
end

Ed25519.test
