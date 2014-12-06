module Sinatra
  module Schema
    class Root
      include Singleton

      attr_accessor :resources

      def initialize
        @resources = {}
      end

      def add_resource(res)
        @resources[res.id] = res
      end

      def find_definition(id)
        resource_id, def_id = id.to_s.split("/", 2)
        return unless resource = resources[resource_id.to_sym]
        resource.defs[def_id.to_sym]
      end

      def to_schema
        {
          "$schema" => "http://json-schema.org/draft-04/hyper-schema",
          "definitions" => resources.inject({}) { |result, (id, resource)|
            result[id] = resource.to_schema
            result
          }
        }
      end
    end
  end
end
