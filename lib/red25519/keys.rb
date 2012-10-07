require 'securerandom'

module Ed25519
  class SigningKey
    attr_reader :verify_key

    def self.generate
      new SecureRandom.random_bytes(Ed25519::SECRET_KEY_BYTES / 2)
    end

    def initialize(seed)
      @seed = seed
      verify_key, @signing_key = Ed25519::Engine.create_keypair(seed)
      @verify_key = VerifyKey.new(verify_key)
    end

    def sign(message)
      Ed25519::Engine.sign(@signing_key, message)
    end

    def to_bytes
      @seed
    end
    alias_method :to_s, :to_bytes

    def to_hex
      to_bytes.unpack("H*").first
    end
  end

  class VerifyKey
    def initialize(bytes)
      @key = bytes
    end

    def verify(signature, message)
      Ed25519::Engine.verify(@key, signature, message)
    end

    def to_bytes
      @key
    end
    alias_method :to_s, :to_bytes

    def to_hex
      to_bytes.unpack("H*").first
    end
  end
end
