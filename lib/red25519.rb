require 'red25519/version'
require 'red25519_engine'
require 'red25519/keys'
require 'red25519/jruby_engine' if defined? JRUBY_VERSION

module Ed25519
  SECRET_KEY_BYTES = 32
  PUBLIC_KEY_BYTES = 32
  SIGNATURE_BYTES  = 64

  class SelfTestFailure < StandardError; end

  def self.test
    signature_key = Ed25519::SigningKey.new("A" * 32)

    unless signature_key.verify_key.to_hex == 'db995fe25169d141cab9bbba92baa01f9f2e1ece7df4cb2ac05190f37fcc1f9d'
      raise SelfTestFailure, "failed to generate verify key correctly"
    end

    message = "crypto libraries should self-test on boot"
    signature = signature_key.sign(message)
    unless signature.unpack("H*").first == 'c62c12a3a6cbfa04800d4be81468ef8aecd152a6a26a81d91257baecef13ba209531fe905a843e833c8b71cee04400fa2af3a29fef1152ece470421848758d0a'
      raise SelfTestFailure, "failed to generate correct signature"
    end

    verify_key = signature_key.verify_key
    unless verify_key.verify(signature, message)
      raise SelfTestFailure, "failed to verify a valid signature"
    end

    bad_signature = signature[0...63] + 'X'
    unless verify_key.verify(bad_signature, message) == false
      raise SelfTestFailure, "failed to detect an invalid signature"
    end
  end
end

Ed25519.test

# TIMTOWTDI!!!
Red25519 = Ed25519
