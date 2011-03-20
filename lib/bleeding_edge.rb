#!/opt/local/bin/ruby

require 'rubygems'
require 'installed_gem_future'

class BleedingEdge
  def initialize
    @installed_gems = Array.new
    @fetcher = Gem::SpecFetcher.new
  end

  def find_futures_for_gems
    puts "Looking for most recent versions of installed gems for platform #{Gem.platforms.to_a}..."
    @installed_gems.each do |gem|
      find_future_versions_for(gem)
    end
  end
  
  def find_future_versions_for(gem)
    version_filter = Gem::Requirement.create("> " + gem.installed_version)
    dep = Gem::Dependency.new gem.name, version_filter
    matching_specs = @fetcher.find_matching dep, true, true, false
    matching_specs.each do |spec|
      gem.add_future_version spec[0][1].version
    end
    puts "Found #{gem.count} versions for #{dep}"
  end

  def find_installed_gems(searcher)
    searcher.find_all("*").each do |gem|
      @installed_gems << InstalledGemFuture.new(gem)
    end

    puts "Found #{@installed_gems.size.to_s} installed gems in scope"
    
    @installed_gems
  end

  def output_as_html
    File.open("bleeding-edge-report.html", "w") do |f|
      @installed_gems.sort! { |a,b| b.count <=> a.count}

      f.write File.open("report-header.html", "r").readlines
      @installed_gems.each do |future|
        f.write future.to_html
      end
      f.write File.open("report-footer.html", "r").readlines
    end
  end
end

# be = BleedingEdge.new
# be.find_installed_gems(Gem.searcher)
# be.find_futures_for_gems
# be.output_as_html