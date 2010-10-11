require 'ostruct'

class ObjectGraph
  def self.new(hash)
    OpenStruct.new(
      hash.merge(hash) do |k,v|
        case v
        when Hash then ObjectGraph.new(hash)
        when Array then v.map{ |item| ObjectGraph.new(item) }
        else v
        end
      end
    )
  end
end