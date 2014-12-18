module Sinatra
  module Schema
    class Reference
      attr_accessor :id, :ref_spec, :referenced_def, :resource

      # helper to lazily delegate method to the referenced definition
      def self.delegate(attribute)
        define_method(attribute) do |*args|
          resolve!
          referenced_def.send(attribute, *args)
        end
      end

      def initialize(resource, id, ref_spec=nil)
        @id = id
        @ref_spec = ref_spec || id
        @resource = resource
      end

      def resolve!
        return if referenced_def
        unless @referenced_def = resource.defs[ref_spec] || Sinatra::Schema::Root.instance.find_definition(ref_spec)
          raise BadReference.new(ref_spec)
        end
        return @referenced_def
      end

      delegate :cast
      delegate :description
      delegate :example
      delegate :optional
      delegate :type
      delegate :valid?
    end
  end
end
