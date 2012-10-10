Red25519
========
[![Build Status](https://secure.travis-ci.org/tarcieri/red25519.png?branch=master)](http://travis-ci.org/tarcieri/red25519)

![Ed25519 Diagram](https://raw.github.com/tarcieri/red25519/master/ed25519.png)

Red25519 provides a Ruby binding to the Ed25519 public-key signature system
based on elliptic curves and created by Dan Bernstein et al. An implementation
in C is taken from the SUPERCOP benchmark suite. Ed25519 provides a 128-bit
security level, that is to say, all known attacks take at least 2^128
operations, providing the same security level as AES-128, NIST P-256, and
RSA-3072.

Ed25519 has a number of unique properties that make it one of the best-in-class
digital signature algorithms:

* ***Small keys***: Ed25519 keys are only 256-bits (32 bytes), making them
  small enough to easily copy around. Ed25519 also allows the public key
  to be derived from the private key, meaning that it doesn't need to be
  included in a serialized private key in cases you want both.
* ***Small signatures***: Ed25519 signatures are only 512-bits (64 bytes),
  one of the smallest signature sizes available.
* ***Deterministic***: Unlike (EC)DSA, Ed25519 does not rely on an entropy
  source when signing messages. This can be a potential attack vector if
  the entropy source is not generating good random numbers. Ed25519 avoids
  this problem entirely and will always generate the same signature for the
  same data.
* ***Collision Resistant***: Hash-function collisions do not break this
  system. This adds a layer of defense against the possibility of weakness
  in the selected hash function.

You can read more on [Dan Bernstein's Ed25519 site](http://ed25519.cr.yp.to/).

Installation
------------

Add this line to your application's Gemfile:

    gem 'red25519'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install red25519

Usage
-----

Require red25519 in your Ruby program:

```ruby
require 'red25519'
```

Generate a new random signing key:

```ruby
signing_key = Ed25519::SigningKey.generate
```

Sign a message with the signing key:

```ruby
signature = signing_key.sign(message)
```

Obtain the verify key for a given signing key:

```ruby
verify_key = signing_key.verify_key
```

Check the validity of a signature:

```ruby
verify_key.verify(signature, message)
```

The verify method will return `true` or `false` depending on if the signature matches.

### Serializing Keys

Keys can be serialized as 32-byte binary strings as follows:

```ruby
signature_key_bytes = signing_key.to_bytes
verify_key_bytes = verify_key.to_bytes
```

The binary serialization can be passed directly into the constructor for a given key type:

```ruby
signing_key = Ed25519::SigningKey.new(signature_key_bytes)
verify_key  = Ed25519::VerifyKey.new(verify_key_bytes)
```

You can also serialize keys to a hex string instead of a binary string:

```ruby
signing_key_hex = signing_key.to_hex
```

The hex representation can also be passed into the constructor:

```ruby
signing_key = Ed25519::SigningKey.new(signing_key_hex)
```

Contributing
------------

* Fork this repository on github
* Make your changes and send me a pull request
* If I like them I'll merge them
* If I've accepted a patch, feel free to ask for commit access

License
-------

Copyright (c) 2012 Tony Arcieri. Distributed under the MIT License. See
LICENSE for further details.
