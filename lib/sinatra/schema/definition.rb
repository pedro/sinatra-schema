module Sinatra
  module Schema
    class Definition
      attr_accessor :description, :example, :format, :id, :type

      def initialize(options)
        @description = options[:description]
        @example     = options[:example]
        @id          = options[:id]
        @type        = options[:type]
      end
    end
  end
end
