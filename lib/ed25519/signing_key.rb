# frozen_string_literal: true

require "securerandom"

module Ed25519
  # Private key for producing digital signatures
  class SigningKey
    attr_reader :verify_key

    # Generate a random Ed25519 signing key (i.e. private scalar)
    def self.generate
      new SecureRandom.random_bytes(Ed25519::KEY_SIZE)
    end

    # Create a new Ed25519::SigningKey from the given seed value
    #
    # @param seed [String] 32-byte seed value from which the key should be derived
    def initialize(seed)
      raise ArgumentError, "seed must be #{KEY_SIZE}-bytes long" unless seed.length == KEY_SIZE
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
