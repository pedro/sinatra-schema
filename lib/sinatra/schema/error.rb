module Sinatra
  module Schema
    class Error < StandardError
    end

    class BadReference < Error
      def initialize(id)
        super("Could not resolve property ref #{id}")
      end
    end

    class BadRequest < Error
      def initialize(msg)
        super(msg)
      end
    end

    class BadParams < Error
      def initialize(msg)
        super(msg)
      end
    end

    class BadResponse < Error
      def initialize(msg)
        super(msg)
      end
    end
  end
end
