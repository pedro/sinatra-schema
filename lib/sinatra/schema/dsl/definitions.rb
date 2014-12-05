module Sinatra
  module Schema
    module DSL
      class Definitions
        attr_accessor :definition, :resource, :options

        def initialize(resource, options={})
          @options  = options
          @resource = resource
        end

        def text(id, local_options={})
          def_options = options.merge(local_options)
          def_options.merge!(id: id, type: "string")
          add Definition.new(def_options)
        end

        # TODO support other types

        protected

        def add(definition)
          @resource.defs[definition.id] = definition
          if options[:serialize]
            @resource.properties << definition
          end
          if link = options[:link]
            link.properties << definition
          end
        end
      end
    end
  end
end
