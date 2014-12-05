module Sinatra
  module Schema
    class Root
      include Singleton

      attr_accessor :resources

      def initialize
        @resources = {}
      end

      def add_resource(res)
        @resources[res.id] = res
      end
    end
  end
end
