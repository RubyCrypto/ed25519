#include "ruby.h"
#include "crypto_sign.h"

static VALUE mEd25519 = Qnil;
static VALUE mEd25519_Engine = Qnil;

static VALUE Ed25519_Engine_create_keypair(VALUE self, VALUE seed);
static VALUE Ed25519_Engine_sign(VALUE self, VALUE signing_key, VALUE msg);
static VALUE Ed25519_Engine_verify(VALUE self, VALUE verify_key, VALUE signature, VALUE msg);

void Init_red25519_engine()
{
    mEd25519 = rb_define_module("Ed25519");
    mEd25519_Engine = rb_define_module_under(mEd25519, "Engine");

    rb_define_singleton_method(mEd25519_Engine, "create_keypair", Ed25519_Engine_create_keypair, 1);
    rb_define_singleton_method(mEd25519_Engine, "sign", Ed25519_Engine_sign, 2);
    rb_define_singleton_method(mEd25519_Engine, "verify", Ed25519_Engine_verify, 3);
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

static VALUE Ed25519_Engine_sign(VALUE self, VALUE signing_key, VALUE msg)
{
    unsigned char *sig_and_msg;
    unsigned long long sig_and_msg_len;
    VALUE result;

    if(RSTRING_LEN(signing_key) != SECRETKEYBYTES)
        rb_raise(rb_eArgError, "private signing keys must be %d bytes", SECRETKEYBYTES);

    sig_and_msg = (unsigned char *)xmalloc(SIGNATUREBYTES + RSTRING_LEN(msg));
    crypto_sign(sig_and_msg, &sig_and_msg_len, RSTRING_PTR(msg), RSTRING_LEN(msg), RSTRING_PTR(signing_key));
    result = rb_str_new(sig_and_msg, SIGNATUREBYTES);
    free(sig_and_msg);

    return result;
}

static VALUE Ed25519_Engine_verify(VALUE self, VALUE verify_key, VALUE signature, VALUE msg)
{
    unsigned char *sig_and_msg;
    unsigned long long msg_len, sig_and_msg_len;
    int result;

    if(RSTRING_LEN(verify_key) != PUBLICKEYBYTES)
      rb_raise(rb_eArgError, "public verify keys must be %d bytes", PUBLICKEYBYTES);

    if(RSTRING_LEN(signature) != SIGNATUREBYTES)
      rb_raise(rb_eArgError, "public verify keys must be %d bytes", PUBLICKEYBYTES);

    sig_and_msg_len = SIGNATUREBYTES + RSTRING_LEN(msg);
    sig_and_msg = (unsigned char *)xmalloc(sig_and_msg_len);
    memcpy(sig_and_msg, RSTRING_PTR(signature), SIGNATUREBYTES);
    memcpy(sig_and_msg + SIGNATUREBYTES, RSTRING_PTR(msg), RSTRING_LEN(msg));

    result = crypto_sign_open(
        RSTRING_PTR(msg), &msg_len,
        sig_and_msg, sig_and_msg_len,
        RSTRING_PTR(verify_key));

    free(sig_and_msg);

    return result == 0 ? Qtrue : Qfalse;
}
