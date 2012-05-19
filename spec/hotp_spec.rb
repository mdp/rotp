require 'spec_helper'

describe ROTP::HOTP do
  before(:all) { @now = Time.utc(2012,1,1).to_i / 30 }

  subject { ROTP::HOTP.new('a' * 32) }

  it "should generate a number given a time" do
    subject.at(@now).should == 160864
  end
  it "should verify a number" do
    subject.verify(160864, @now).should be_true
  end
  it "should verify a string" do
    subject.verify("160864", @now).should be_true
  end
end
