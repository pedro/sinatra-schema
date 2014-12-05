module Sinatra
  module Schema
    class Definition
      attr_accessor :description, :example, :format, :type

      def initialize(options)
        @id          = options[:id]
        @description = options[:description]
        @example     = options[:example]
        @type        = options[:type]
      end
    end
  end
end
