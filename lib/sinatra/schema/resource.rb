module Sinatra
  module Schema
    class Resource
      attr_accessor :id, :path, :title, :defs, :links, :description, :properties

      def initialize(options)
        @path       = options.fetch(:path).chomp("/")
        @links      = []
        @defs       = {}
        @properties = {}
      end

      def id
        @id ||= ActiveSupport::Inflector.singularize(path.split("/").last).to_sym
      end

      def title
        @title ||= ActiveSupport::Inflector.singularize(path.split("/").last).capitalize
      end

      def validate_response!(rel, raw)
        # only validate responses in tests
        return unless ENV["RACK_ENV"] == "test"

        res = MultiJson.decode(raw)

        if rel == :instances
          unless res.is_a?(Array)
            raise BadResponse.new("Response should return an array")
          end
          if sample = res.first
            Utils.validate_keys!(properties, sample)
          end
        else
          unless res.is_a?(Hash)
            raise BadResponse.new("Response should return a hash")
          end
          Utils.validate_keys!(properties, res)
        end
      end
    end
  end
end
