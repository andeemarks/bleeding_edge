require 'spec_helper'
require File.dirname(__FILE__) + '/../lib/installed_gem_future'

describe InstalledGemFuture do
    
  before :all do
    @spec = Gem::Specification.new do |s|
      s.name = 'name'
      s.version = '1.0'
    end
  end

  it "should keep track of the important details of it's gem" do
    
    future = InstalledGemFuture.new(@spec)
    
    future.name.should == @spec.name
    future.gem.should == @spec
    future.installed_version.should == @spec.version.to_s
  end
  
  describe "when empty" do
    before :each do
      @future = InstalledGemFuture.new(@spec)
    end
    
    it "should have a zero count" do
      @future.count.should == 0
    end
  end
  
  describe "when being populated" do
    before :each do
      @future = InstalledGemFuture.new(@spec)
    end

    it "should increase it's count with each new future" do
      @future.count.should == 0
      @future.add_future_version("2.0")
      
      @future.count.should == 1
    end

    it "should not accept a new version if it already has it" do
      @future.count.should == 0
      @future.add_future_version("2.0")
      @future.add_future_version("2.0")

      @future.count.should == 1
    end

    it "should fail if the present version is added" do
      lambda{@future.add_future_version(@future.installed_version)}.should raise_error
    end

    it "should fail if a past version is added" do
      lambda{@future.add_future_version("0.1")}.should raise_error
    end
  end
  
end