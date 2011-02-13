require 'spec_helper'

describe "generating a random base32 secret" do
  it "should be 16 characters by default" do
    ROTP.random_base32.length.should == 16
    ROTP.random_base32.should match /[a-z2-7].+/
  end
  it "should be allow a specific length" do
    ROTP.random_base32(32).length.should == 32
  end
end

describe "HOTP example values from the rfc" do
  it "should match the RFC" do
    # 12345678901234567890 in Bas32
    # GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ
    hotp = ROTP::HOTP.new("GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ")
    hotp.at(0).should ==(755224)
    hotp.at(1).should ==(287082)
    hotp.at(2).should ==(359152)
    hotp.at(3).should ==(969429)
    hotp.at(4).should ==(338314)
    hotp.at(5).should ==(254676)
    hotp.at(6).should ==(287922)
    hotp.at(7).should ==(162583)
    hotp.at(8).should ==(399871)
    hotp.at(9).should ==(520489)
  end
  it "should output its provisioning URI" do
    hotp = ROTP::HOTP.new("wrn3pqx5uqxqvnqr")
    hotp.provisioning_uri('mark@percival').should == "otpauth://hotp/mark@percival?secret=wrn3pqx5uqxqvnqr&counter=0"
  end
end

describe "TOTP example values from the rfc" do
  it "should match the RFC" do
    totp = ROTP::TOTP.new("GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ")
    totp.at(1111111111).should ==(50471)
    totp.at(1234567890).should ==(5924)
    totp.at(2000000000).should ==(279037)
  end

  it "should match the Google Authenticator output" do
    totp = ROTP::TOTP.new("wrn3pqx5uqxqvnqr")
    Timecop.freeze(Time.at(1297553958)) do
      totp.now.should ==(102705)
    end
  end

  it "should output its provisioning URI" do
    totp = ROTP::TOTP.new("wrn3pqx5uqxqvnqr")
    totp.provisioning_uri('mark@percival').should == "otpauth://totp/mark@percival?secret=wrn3pqx5uqxqvnqr"
  end
end
