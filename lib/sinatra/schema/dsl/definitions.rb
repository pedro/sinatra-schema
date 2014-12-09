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

        # support nested properties. eg: property[:foo].text :bar
        def [](id)
          # make sure all targets have a sub-hash for this nested def:
          targets.each { |h| h[id] ||= {} }

          # return a new DSL with updated targets so it can be chained:
          Definitions.new(resource, targets.map { |h| h[id] })
        end

        def ref(id, ref_to=nil)
          ref_to ||= id
          unless definition = resource.defs[ref_to] || Sinatra::Schema::Root.instance.find_definition(ref_to)
            raise BadReference.new(id)
          end
          add definition, true, id
        end

        # TODO support other types

        protected

        def add(definition, reference=false, id=nil)
          id ||= definition.id
          targets.each_with_index do |hash, i|
            # here's the trick, and here's why the first target is always the
            # resource def: skip it when adding a reference (eg: it's already)
            # in the resource def, just add the property!
            next if reference && i == 0
            hash[id] = definition
          end
        end
      end
    end
  end
end
