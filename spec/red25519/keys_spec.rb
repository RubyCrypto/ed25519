require 'spec_helper'

describe Ed25519::SigningKey do
  it "generates keypairs" do
    key = Ed25519::SigningKey.generate
    key.should be_a Ed25519::SigningKey
    key.verify_key.should be_a Ed25519::VerifyKey
  end
end

describe Ed25519::VerifyKey do

end
