#include "ruby.h"

static VALUE mEd25519 = Qnil;
static VALUE mEd25519_Engine = Qnil;

void Init_red25519_engine()
{
    mEd25519 = rb_define_module("Ed25519");
    mEd25519_Engine = rb_define_module_under(mEd25519, "Engine");
}