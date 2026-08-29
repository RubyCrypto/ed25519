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

    # Create a SigningKey from a 64-byte Ed25519 keypair (i.e. public + private)
    #
    # @param keypair [String] 64-byte keypair value containing both seed + public key
    def self.from_keypair(keypair)
      raise TypeError, "expected String, got #{keypair.class}" unless keypair.is_a?(String)
      raise ArgumentError, "expected 64-byte String, got #{keypair.bytesize}" unless keypair.bytesize == 64

      new(keypair[0, KEY_SIZE]).tap do |key|
        raise ArgumentError, "corrupt keypair" unless keypair[KEY_SIZE, KEY_SIZE] == key.verify_key.to_bytes
      end
    end

    # Create a new Ed25519::SigningKey from the given seed value
    #
    # @param seed [String] 32-byte seed value from which the key should be derived
    def initialize(seed)
      Ed25519.validate_key_bytes(seed)

      @seed = seed.dup.freeze
      @keypair = Ed25519.provider.create_keypair(@seed).freeze
      @verify_key = VerifyKey.new(@keypair[32, 32])
    end

    # Return a copy of the seed used to derive this signing key
    def seed
      @seed.dup
    end

    # Return a copy of the 64-byte private/public keypair
    def keypair
      @keypair.dup
    end

    # Sign the given message, returning an Ed25519 signature
    #
    # @param message [String] message to be signed
    #
    # @return [String] 64-byte Ed25519 signature
    def sign(message)
      Ed25519.provider.sign(@keypair, message)
    end

    # String inspection that does not leak secret values
    def inspect
      to_s
    end

    # Return a bytestring representation of this signing key
    #
    # @return [String] signing key converted to a bytestring
    def to_bytes
      @seed.dup
    end
    alias to_str to_bytes
  end
end
