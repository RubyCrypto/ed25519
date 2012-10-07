require 'securerandom'
require 'hkdf'

module Ed25519
  class SigningKey
    attr_reader :verify_key

    def self.generate
      random_bytes = SecureRandom.random_bytes(Ed25519::SECRET_KEY_BYTES)
      hkdf = HKDF.new(random_bytes)
      new hkdf.next_bytes(Ed25519::SECRET_KEY_BYTES)
    end

    def initialize(seed)
      case seed.length
      when 32
        @seed = seed
      when 64
        @seed = [seed].pack("H*")
      else raise ArgumentError, "seed must be 32 or 64 bytes long"
      end

      verify_key, @signing_key = Ed25519::Engine.create_keypair(@seed)
      @verify_key = VerifyKey.new(verify_key)
    end

    def sign(message)
      Ed25519::Engine.sign(@signing_key, message)
    end

    def inspect
      "#<Ed25519::SigningKey:#{to_hex}>"
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
    def initialize(string)
      case string.length
      when 32
        @key = string
      when 64
        @key = [string].pack("H*")
      else raise ArgumentError, "seed must be 32 or 64 bytes long"
      end
    end

    def verify(signature, message)
      Ed25519::Engine.verify(@key, signature, message)
    end

    def inspect
      "#<Ed25519::VerifyKey:#{to_hex}>"
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
