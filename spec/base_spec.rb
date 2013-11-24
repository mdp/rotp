require File.dirname(__FILE__) + '/spec_helper'

describe "the Base32 implementation" do
  it "should be 16 characters by default" do
    ROTP::Base32.random_base32.length.should == 16
    ROTP::Base32.random_base32.should match /\A[a-z2-7]+\z/
  end
  it "should be allow a specific length" do
    ROTP::Base32.random_base32(32).length.should == 32
  end
  it "raise a sane error on a bad decode" do
    expect { ROTP::Base32.decode("4BCDEFG234BCDEF1") }.to raise_error(ROTP::Base32::Base32Error)
  end
  it "should correctly decode a string" do
    ROTP::Base32.decode("F").unpack('H*').first.should == "28"
    ROTP::Base32.decode("23").unpack('H*').first.should == "d6"
    ROTP::Base32.decode("234").unpack('H*').first.should == "d6f8"
    ROTP::Base32.decode("234A").unpack('H*').first.should == "d6f800"
    ROTP::Base32.decode("234B").unpack('H*').first.should == "d6f810"
    ROTP::Base32.decode("234BCD").unpack('H*').first.should == "d6f8110c"
    ROTP::Base32.decode("234BCDE").unpack('H*').first.should == "d6f8110c80"
    ROTP::Base32.decode("234BCDEFG").unpack('H*').first.should == "d6f8110c8530"
    ROTP::Base32.decode("234BCDEFG234BCDEFG").unpack('H*').first.should == "d6f8110c8536b7c0886429"
  end
end

