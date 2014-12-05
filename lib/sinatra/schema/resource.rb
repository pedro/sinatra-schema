module Sinatra
  module Schema
    class Resource
      attr_accessor :id, :path, :title, :description, :properties

      def initialize(app, path)
        @app   = app
        @path  = path.chomp("/")
        @links = []
        @defs  = {}
      end

      def define(id)
        @defs[id] = Definition.new
        yield @defs[id]
      end

      def link(method, href="/", &blk)
        href = "#{path}/#{href.chomp("/")}".chomp("/")
        link = Link.new(resource: self, method: method, href: href)
        yield(link)
        link.register(@app)
        @links << link
      end

      def validate_response!(res)
        unless res.is_a?(Hash)
          raise "Response should return a hash"
        end

        if properties
          Utils.validate_keys!(properties, res)
        end
      end

      def to_schema
        {
          title: title,
          description: description
        }
      end
    end
  end
end
