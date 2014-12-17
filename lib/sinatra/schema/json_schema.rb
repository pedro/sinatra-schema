module Sinatra
  module Schema
    class JsonSchema
      attr_accessor :root

      def self.dump(root)
        new(root).dump_root
      end

      def initialize(root)
        @root = root
      end

      def dump_root
        {
          "$schema" => "http://json-schema.org/draft-04/hyper-schema",
          "definitions" => root.resources.inject({}) { |result, (id, resource)|
            result.merge(id => dump_resource(resource))
          }
        }
      end

      def dump_resource(resource)
        {
          title: resource.title,
          description: resource.description,
          type: "object",
          definitions: resource.defs.inject({}) { |h, (id, definition)|
            h.merge(id => definition.to_schema)
          },
          links: resource.links.map(&:to_schema)
        }
      end
    end
  end
end
