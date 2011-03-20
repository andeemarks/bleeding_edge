require 'gem_version_comparator'

class InstalledGemFuture
  attr_reader :gem, :installed_version, :name
  
  def initialize(gem)
    @gem = gem
    @name = gem.name
    @installed_version = gem.version.to_s
    @futures = Array.new
  end
  
  def add_future_version(version)
    raise RuntimeError if Gem::Version.create(version) <= Gem::Version.create(@installed_version)
    
    @futures << version unless @futures.include? version
  end
  
  def count
    @futures.size
  end
  
  def inspect
    "#{@name} (#{@installed_version}): #{PP.pp(@futures, ' ')}" 
  end
  
  def to_html
    "<tr><td class='gem'>#{@name}</td><td class='current-version'>#{@installed_version}</td><td class='versions-behind'>#{versions_behind}</td>#{futures_to_html}</tr>" 
  end
  
  private
  
  def versions_behind
    count
  end
  
  def futures_to_html
    html = ""
    previous_version = @installed_version
    comparator = GemVersionComparator.new
    @futures.each do |future|
      html << "<td class='#{comparator.difference_between({:from => previous_version, :to => future})}'>#{future}</td>"
      previous_version = future
    end
    
    html
  end
end
