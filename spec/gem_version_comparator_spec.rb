require 'spec_helper'
require File.dirname(__FILE__) + '/../lib/gem_version_comparator'

describe GemVersionComparator do
  before :all do
    @comparator = GemVersionComparator.new
  end
  
  it "should fail unless both versions are supplied" do
    lambda{@comparator.difference_between({:from => "1.2.3"})}.should raise_error
    lambda{@comparator.difference_between({:to => "1.2.3"})}.should raise_error
    lambda{@comparator.difference_between(nil)}.should raise_error
  end
  
  it "should report a trivial change between identical versions" do
    @comparator.difference_between({:from => "1.2.3", :to => "1.2.3"}).should == "trivial"
  end
  
  it "should report a trivial change between versions with more than three components" do
    @comparator.difference_between({:from => "1.2.3", :to => "1.2.3.1"}).should == "trivial"
  end
  
  it "should report a major change when just most significant version number changes" do
    @comparator.difference_between({:from => "1.2.3", :to => "2.2.3"}).should == "major"
  end
  
  it "should report a minor change when just second most significant version number changes" do
    @comparator.difference_between({:from => "1.2.3", :to => "1.3.3"}).should == "minor"
  end
  
  it "should report a build change when just last version number changes" do
    @comparator.difference_between({:from => "1.2.3", :to => "1.2.4"}).should == "build"
  end
  
  it "should report an unknown change when either version does not have all components" do
    @comparator.difference_between({:from => "1.2", :to => "1.2.4"}).should == "unknown"
    @comparator.difference_between({:from => "1.2.3", :to => "1.2"}).should == "unknown"
  end
end