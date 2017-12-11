# frozen_string_literal: true

require "securerandom"

module Ed25519
  # Private key for producing digital signatures
  class SigningKey
    attr_reader :verify_key

    def self.generate
      new SecureRandom.random_bytes(Ed25519::SECRET_KEY_BYTES)
    end

    def initialize(seed)
      raise ArgumentError, "seed must be 32 bytes long" unless seed.length == SECRET_KEY_BYTES
      @seed = seed

      verify_key, @signing_key = Ed25519::Engine.create_keypair(seed)
      @verify_key = VerifyKey.new(verify_key)
    end

    def sign(message)
      Ed25519::Engine.sign(@signing_key, message)
    end

    def inspect
      to_s
    end

    def to_bytes
      @seed
    end
    alias to_str to_bytes
  end
end
