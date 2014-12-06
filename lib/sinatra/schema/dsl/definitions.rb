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

        def bool(id, local_options={})
          def_options = options.merge(local_options)
          def_options.merge!(id: id, type: "boolean")
          add Definition.new(def_options)
        end

        def ref(id)
          unless definition = resource.defs[id] || Sinatra::Schema::Root.instance.find_definition(id)
            raise "Unknown reference: #{id}"
          end
          add definition, true
        end

        # TODO support other types

        protected

        def add(definition, reference=false)
          unless reference
            @resource.defs[definition.id] = definition
          end
          if options[:serialize]
            @resource.properties[definition.id] = definition
          end
          if link = options[:link]
            link.properties[definition.id] = definition
          end
        end
      end
    end
  end
end
