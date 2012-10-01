require 'red25519/version'
require 'red25519_engine'
require 'red25519/keys'

module Ed25519
  SECRET_KEY_BYTES = 64
  PUBLIC_KEY_BYTES = 32
  SIGNATURE_BYTES  = 64
end

# TIMTOWTDI!!!
Red25519 = Ed25519