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
end
