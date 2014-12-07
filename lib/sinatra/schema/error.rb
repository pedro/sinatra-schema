module Sinatra
  module Schema
    class Error < StandardError
    end

    class BadReference < Error
      def initialize(id)
        super("Could not resolve property ref #{id}")
      end
    end

    class UnsupportedMediaType < Error
      def initialize(media_type)
        super("Unsupported media type: #{media_type}")
      end
    end
  end
end
