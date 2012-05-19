require 'spec_helper'

describe ROTP::TOTP do
  before(:all) { @now = Time.utc(2012,1,1) }

  subject { ROTP::TOTP.new('a' * 32) }

  it "should generate a number given a number" do
    subject.at(@now).should == 160864
  end
  it "should verify a number" do
    subject.verify(160864, @now).should be_true
  end
  it "should verify a string" do
    subject.verify("160864", @now).should be_true
  end
end
