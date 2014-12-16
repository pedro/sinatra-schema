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

      def validate_response!(raw)
        # only validate responses in tests
        return unless ENV['RACK_ENV'] == 'test'

        res = MultiJson.decode(raw)

        unless properties.empty?
          if res.is_a?(Array)
            res.each { |item| Utils.validate_keys!(properties, item) }
          else
            Utils.validate_keys!(properties, res)
          end
        end
      end

      def to_schema
        {
          title: title,
          description: description,
          type: "object",
          definitions: defs.inject({}) { |h, (id, definition)|
            h.merge(id => definition.to_schema)
          },
          links: links.map(&:to_schema)
        }
      end
    end
  end
end
