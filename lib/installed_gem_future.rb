
class InstalledGemFuture
  attr_reader :gem, :installed_version, :name
  
  def initialize(gem)
    @gem = gem
    @name = gem.name
    @installed_version = gem.version.to_s
    @futures = Array.new
  end
  
  def add_future_version(version)
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
    @futures.each do |future|
      html << "<td class='#{version_change_label(previous_version, future)}'>#{future}</td>"
      previous_version = future
    end
    
    html
  end
  
  def version_change_label(from_version, to_version)
    from_components = from_version.split(".")
    to_components = to_version.split(".")
    
    begin
      return "major" if (from_components[0].to_i < to_components[0].to_i)
      return "minor" if (from_components[1].to_i < to_components[1].to_i)
      return "build" if (from_components[2].to_i < to_components[2].to_i)
    rescue NoMethodError
      "unknown"
    end
    
    "trivial"
  end
end
