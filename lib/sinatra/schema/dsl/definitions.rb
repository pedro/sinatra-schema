module Sinatra
  module Schema
    module DSL
      class Definitions
        attr_accessor :resource

        def initialize(resource)
          @resource = resource
        end

        def text(id, options={})
          add Definition.new(options.merge(id: id, type: "string"))
        end

        # TODO support other types

        protected

        def add(definition)
          @resource.defs[definition.id] = definition
        end
      end
    end
  end
end
