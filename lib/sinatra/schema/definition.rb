module Sinatra
  module Schema
    class Definition
      attr_accessor :description, :example, :format, :id, :type

      def initialize(options={})
        @description = options[:description]
        @example     = options[:example]
        @id          = options[:id]
        @type        = options[:type]
      end

      def cast(value)
        # do not touch nulls:
        return unless value

        case type
        when "string"
          value.to_s
        when "boolean"
          %w( t true 1 ).include?(value.to_s)
        end
      end
    end
  end
end
