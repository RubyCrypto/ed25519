# frozen_string_literal: true

module Ed25519
  # Public key for verifying digital signatures
  class VerifyKey
    def initialize(key)
      raise ArgumentError, "seed must be 32 bytes long" unless key.length == PUBLIC_KEY_BYTES
      @key = key
    end

    def verify(signature, message)
      if signature.length != SIGNATURE_BYTES
        raise ArgumentError, "expected #{SIGNATURE_BYTES} byte signature, got #{signature.length}"
      end

      Ed25519::Engine.verify(@key, signature, message)
    end

    def inspect
      to_s
    end

    def to_bytes
      @key
    end
    alias to_str to_bytes
  end
end
