module Sinatra
  module Schema
    class Error < StandardError
    end

    class BadReference < Error
      def initialize(id)
        super("Could not resolve property ref #{id}")
      end
    end
  end
end
