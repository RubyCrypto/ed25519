#include "ruby.h"
#include "crypto_sign.h"

static VALUE mEd25519 = Qnil;
static VALUE mEd25519_Engine = Qnil;

static VALUE Ed25519_Engine_create_keypair(VALUE self, VALUE seed);

void Init_red25519_engine()
{
    mEd25519 = rb_define_module("Ed25519");
    mEd25519_Engine = rb_define_module_under(mEd25519, "Engine");

    rb_define_singleton_method(mEd25519_Engine, "create_keypair", Ed25519_Engine_create_keypair, 1);
}

static VALUE Ed25519_Engine_create_keypair(VALUE self, VALUE seed)
{
    unsigned char verify_key[PUBLICKEYBYTES], signing_key[SECRETKEYBYTES];

    seed = rb_convert_type(seed, T_STRING, "String", "to_str");

    if(RSTRING_LEN(seed) != SECRETKEYBYTES / 2)
        rb_raise(rb_eArgError, "seed must be exactly %d bytes", SECRETKEYBYTES / 2);

    crypto_sign_publickey(verify_key, signing_key, RSTRING_PTR(seed));

    rb_ary_new3(2,
        rb_str_new(verify_key, PUBLICKEYBYTES),
        rb_str_new(signing_key, SECRETKEYBYTES)
    );
}
