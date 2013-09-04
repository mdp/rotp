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
