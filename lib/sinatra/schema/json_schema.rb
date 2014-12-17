module Sinatra
  module Schema
    class JsonSchema
      def self.dump(root)
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
