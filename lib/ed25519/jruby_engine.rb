# frozen_string_literal: true

require "java"

module Ed25519
  # Core functionality provided by an Ed25519 library
  module Engine
    module_function

    def create_keypair(seed)
      raise ArgumentError, "seed must be 32 bytes long" unless seed.length == 32

      verify_key = org.cryptosphere.ed25519.publickey(seed.to_java_bytes)
      verify_key = String.from_java_bytes(verify_key)
      [verify_key, seed + verify_key]
    end

    def sign(signing_key, message)
      verify_key  = signing_key[32...64].to_java_bytes
      signing_key = signing_key[0...32].to_java_bytes

      signature = org.cryptosphere.ed25519.signature(message.to_java_bytes, signing_key, verify_key)
      String.from_java_bytes(signature)
    end

    def verify(verify_key, signature, message)
      org.cryptosphere.ed25519.checkvalid(signature.to_java_bytes, message.to_java_bytes, verify_key.to_java_bytes)
    end
  end
end
