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
  end

  class VerifyKey
    def initialize(bytes)
      @key = bytes
    end
  end
end
