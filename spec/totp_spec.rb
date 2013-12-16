require 'spec_helper'

describe ROTP::TOTP do
  before(:all) { @now = Time.utc(2012,1,1) }

  subject { ROTP::TOTP.new("JBSWY3DPEHPK3PXP") }

  it "should generate a number given a number" do
    subject.at(@now).should == 68212
  end
  it "should generate a number as a padded string" do
    subject.at(@now, true).should == "068212"
  end
  it "should verify a number" do
    subject.verify(68212, @now).should be_true
  end
  it "should verify a string" do
    subject.verify("68212", @now).should be_true
  end

  it "should output its provisioning URI" do
    url = subject.provisioning_uri('mark@percival')
    params = CGI::parse(URI::parse(url).query)
    url.should match(/otpauth:\/\/totp.+/)
    params["secret"].first.should == "JBSWY3DPEHPK3PXP"
  end

  context  "with issuer" do
    subject { ROTP::TOTP.new("JBSWY3DPEHPK3PXP", :issuer => "FooCo") }
    it "should output its provisioning URI with issuer" do
      url = subject.provisioning_uri('mark@percival')
      params = CGI::parse(URI::parse(url).query)
      url.should match(/otpauth:\/\/totp.+/)
      params["secret"].first.should == "JBSWY3DPEHPK3PXP"
      params["issuer"].first.should == "FooCo"
    end
  end

  context  "with non default interval" do
    subject { ROTP::TOTP.new("JBSWY3DPEHPK3PXP", :interval => 60) }
    it "should output its provisioning URI with issuer" do
      url = subject.provisioning_uri('mark@percival')
      params = CGI::parse(URI::parse(url).query)
      url.should match(/otpauth:\/\/totp.+/)
      params["secret"].first.should == "JBSWY3DPEHPK3PXP"
      params["period"].first.should == "60"
    end
  end


  context "with drift" do
    it "should verify a number" do
      subject.verify_with_drift(68212, 0, @now).should be_true
    end
    it "should verify a string" do
      subject.verify_with_drift("68212", 0, @now).should be_true
    end
    it "should verify a slightly old number" do
      subject.verify_with_drift(subject.at(@now - 30), 60, @now).should be_true
    end
    it "should verify a slightly new number" do
      subject.verify_with_drift(subject.at(@now + 60), 60, @now).should be_true
    end
    it "should reject a number that is outside the allowed drift" do
      subject.verify_with_drift(subject.at(@now - 60), 30, @now).should be_false
    end
    context "with drift that is not a multiple of the TOTP interval" do
      it "should verify a slightly old number" do
        subject.verify_with_drift(subject.at(@now - 45), 45, @now).should be_true
      end
      it "should verify a slightly new number" do
        subject.verify_with_drift(subject.at(@now + 40), 40, @now).should be_true
      end
    end
  end
end

describe "TOTP example values from the documented output" do
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
  it "should match Dropbox 26 char secret output" do
    totp = ROTP::TOTP.new("tjtpqea6a42l56g5eym73go2oa")
    Timecop.freeze(Time.at(1378762454)) do
      totp.now.should ==(747864)
    end
  end
  it "should validate a time based OTP" do
    totp = ROTP::TOTP.new("wrn3pqx5uqxqvnqr")
    Timecop.freeze(Time.at(1297553958)) do
      totp.verify(102705).should be_true
    end
    Timecop.freeze(Time.at(1297553958 + 30)) do
      totp.verify(102705).should be_false
    end
  end
end
