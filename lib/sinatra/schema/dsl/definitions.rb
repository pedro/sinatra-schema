module Sinatra
  module Schema
    module DSL
      class Definitions
        attr_accessor :definition, :resource, :options, :targets

        def initialize(resource, targets)
          @resource = resource
          # array of hashes to receive the definition, first is the resource defs
          @targets  = targets
        end

        def bool(id, options={})
          options.merge!(id: id, type: "boolean")
          add Definition.new(options)
        end

        def datetime(id, options={})
          options.merge!(id: id, type: "datetime")
          add Definition.new(options)          
        end

        def email(id, options={})
          options.merge!(id: id, type: "email")
          add Definition.new(options)
        end

        def int(id, options={})
          options.merge!(id: id, type: "integer")
          add Definition.new(options)
        end

        def object(id, options={})
          options.merge!(id: id, type: "object")
          add Definition.new(options)
        end

        # support references to other properties that are lazily evaluated
        def ref(id, options={})
          add Reference.new(resource, id, options)
        end

        def text(id, options={})
          options.merge!(id: id, type: "string")
          add Definition.new(options)
        end

        def uuid(id, options={})
          options.merge!(id: id, type: "uuid")
          add Definition.new(options)
        end

        # support nested properties. eg: property[:foo].text :bar
        def [](id)
          # make sure all targets have a sub-hash for this nested def
          targets.each { |h| h[id] ||= {} }

          # return a new DSL with updated targets so it can be chained
          Definitions.new(resource, targets.map { |h| h[id] })
        end

        protected

        def add(definition)
          targets.each do |target|
            target[definition.id] ||= definition
          end
        end
      end
    end
  end
end
