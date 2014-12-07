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

        def text(id, options={})
          options.merge!(id: id, type: "string")
          add Definition.new(options)
        end

        def bool(id, options={})
          options.merge!(id: id, type: "boolean")
          add Definition.new(options)
        end

        def uuid(id, options={})
          options.merge!(id: id, type: "uuid")
          add Definition.new(options)
        end

        def email(id, options={})
          options.merge!(id: id, type: "email")
          add Definition.new(options)
        end

        def nested(id)
          # add a space in the definitions/properties for the nested def:
          targets.each { |h| h[id] = {} }

          # yield a new DSL with updated targets
          yield Definitions.new(resource, targets.map { |h| h[id] })
        end

        def ref(id)
          unless definition = resource.defs[id] || Sinatra::Schema::Root.instance.find_definition(id)
            raise BadReference.new(id)
          end
          add definition, true
        end

        # TODO support other types

        protected

        def add(definition, reference=false)
          targets.each_with_index do |hash, i|
            # here's the trick, and here's why the first target is always the
            # resource def: skip it when adding a reference (eg: it's already)
            # in the resource def, just add the property!
            next if reference && i == 0
            hash[definition.id] = definition
          end
        end
      end
    end
  end
end
