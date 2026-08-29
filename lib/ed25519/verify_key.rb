# frozen_string_literal: true

module Ed25519
  # Public key for verifying digital signatures
  class VerifyKey
    SCALAR_ORDER = [
      0xed, 0xd3, 0xf5, 0x5c, 0x1a, 0x63, 0x12, 0x58,
      0xd6, 0x9c, 0xf7, 0xa2, 0xde, 0xf9, 0xde, 0x14,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10
    ].pack("C*").freeze
    private_constant :SCALAR_ORDER

    # Create a Ed25519::VerifyKey from its serialized Twisted Edwards representation
    #
    # @param key [String] 32-byte string representing a serialized public key
    def initialize(key)
      Ed25519.validate_key_bytes(key)
      @key_bytes = key
    end

    # Verify an Ed25519 signature against the message
    #
    # @param signature [String] 64-byte string containing an Ed25519 signature
    # @param message [String] string containing message to be verified
    #
    # @raise Ed25519::VerifyError signature verification failed
    #
    # @return [true] message verified successfully
    def verify(signature, message)
      if signature.bytesize != SIGNATURE_SIZE
        raise ArgumentError, "expected #{SIGNATURE_SIZE} byte signature, got #{signature.bytesize}"
      end

      return true if canonical_scalar?(signature) && Ed25519.provider.verify(@key_bytes, signature, message)

      raise VerifyError, "signature verification failed!"
    end

    # Return a compressed twisted Edwards coordinate representing the public key
    #
    # @return [String] bytestring serialization of this public key
    def to_bytes
      @key_bytes
    end
    alias to_str to_bytes

    # Show hex representation of serialized coordinate in string inspection
    def inspect
      "#<#{self.class}:#{@key_bytes.unpack1('H*')}>"
    end

    private

    def canonical_scalar?(signature)
      (KEY_SIZE - 1).downto(0) do |index|
        scalar_byte = signature.getbyte(KEY_SIZE + index)
        order_byte = SCALAR_ORDER.getbyte(index)
        return scalar_byte < order_byte if scalar_byte != order_byte
      end

      false
    end
  end
end
