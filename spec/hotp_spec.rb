require 'spec_helper'

describe ROTP::HOTP do
  before(:all) { @counter = 1234 }

  subject { ROTP::HOTP.new('a' * 32) }

  it "should generate a number given a time" do
    subject.at(@counter).should == 161024
  end
  it "should generate a number as a string" do
    subject.at(@counter, true).should == "161024"
  end
  it "should verify a number" do
    subject.verify(161024, @counter).should be_true
  end
  it "should verify a string" do
    subject.verify("161024", @counter).should be_true
  end
  it "should output its provisioning URI" do
    url = subject.provisioning_uri('mark@percival')
    params = CGI::parse(URI::parse(url).query)
    url.should match(/otpauth:\/\/hotp.+/)
    params["secret"].first.should == "a" * 32
  end

  context "with retries" do
    it "should verify that retry is a valid number" do
      subject.verify_with_retries(161024, @counter, -1).should be_false
      subject.verify_with_retries(161024, @counter, 0).should be_false
    end

    it "should verify up to the total number of retries and return the counter" do
      subject.verify_with_retries(161024, @counter - 10, 10).should == @counter
    end

    it "should verify that retry is a valid number" do
      subject.verify_with_retries(161024, @counter - 20, 10).should be_false
    end
  end
end

describe "HOTP example values from the rfc" do
  it "should match the RFC" do
    # 12345678901234567890 in Base32
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
  it "should verify an OTP and not allow reuse" do
    hotp = ROTP::HOTP.new("GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ")
    hotp.verify(520489, 9).should be_true
    hotp.verify(520489, 10).should be_false
  end
end
