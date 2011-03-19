class GemVersionComparator
  def difference_between(versions)
    raise RuntimeError unless versions[:from] && versions[:to]

    from_components = versions[:from].split(".")
    to_components = versions[:to].split(".")
    
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