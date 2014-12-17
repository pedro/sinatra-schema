module Sinatra
  module Schema
    class JsonSchema
      def self.dump_root(root)
        {
          "$schema" => "http://json-schema.org/draft-04/hyper-schema",
          "definitions" => root.resources.inject({}) { |result, (id, resource)|
            result[id] = resource.to_schema
            result
          }
        }
      end
    end
  end
end
