module Sinatra
  module Schema
    class Definition
      attr_accessor :description, :example, :id, :type

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
        when "boolean"
          %w( t true 1 ).include?(value.to_s)
        when "email", "string", "uuid"
          value.to_s
        end
      end

      def valid?(value)
        # always accept nils for now
        return if value.nil?

        case type
        when "boolean"
          [true, false].include?(value)
        when "email"
          value.to_s =~ /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
        when "string"
          value.is_a?(String)
        when "uuid"
          value.to_s =~ /\A[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}\Z/
        end
      end
    end
  end
end
