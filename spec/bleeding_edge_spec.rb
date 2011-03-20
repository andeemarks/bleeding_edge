require 'rubygems'
require File.dirname(__FILE__) + '/../lib/bleeding_edge'

describe BleedingEdge do
  Struct.new("Gem", :name, :version)
  first_gem = Struct::Gem.new("first", "1.0")
  second_gem = Struct::Gem.new("second", "2.3.2")
  be = BleedingEdge.new

  it "should create a future for each installed gem" do
    searcher = mock("searcher")
    searcher.should_receive(:find_all).and_return(Array[first_gem, second_gem])
    installed_gems = be.find_installed_gems(searcher)
    
    installed_gems.count.should == 2
  end

  it "should store each installed gem as a future" do
    searcher = mock("searcher")
    searcher.should_receive(:find_all).and_return(Array[first_gem])
    installed_gems = be.find_installed_gems(searcher)
    
    installed_gems.first.installed_version should == first_gem.version
    installed_gems.first.name should == first_gem.name
  end
end
