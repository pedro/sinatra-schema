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
            h.merge(id => dump_definition(definition))
          },
          links: resource.links.map(&:to_schema)
        }
      end

      def dump_definition(definition)
        schema_type, schema_format = json_schema_type_and_format(definition.type)
        attrs = { type: schema_type }
        if schema_format
          attrs[:format] = schema_format
        end
        if definition.description
          attrs[:description] = definition.description
        end
        attrs
      end

      protected

      def json_schema_type_and_format(type)
        case type
        when "boolean"
          "boolean"
        when "email"
          ["string", "email"]
        when "string"
          "string"
        when "uuid"
          ["string", "uuid"]
        end
      end
    end
  end
end
