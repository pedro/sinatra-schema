module Sinatra
  module Schema
    class JsonSchema
      attr_accessor :root

      def self.dump(root)
        new(root).dump
      end

      def initialize(root)
        @root = root
      end

      def dump
        {
          "$schema" => "http://json-schema.org/draft-04/hyper-schema",
          "definitions" => root.resources.inject({}) { |result, (id, resource)|
            result.merge(id => resource.to_schema)
          }
        }
      end
    end
  end
end
