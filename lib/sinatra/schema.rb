module Sinatra
  module Schema
    class Link
      attr_accessor :title, :description, :href, :method, :rel

      def initialize(options)
        @method = options[:method]
        @href   = options[:href]
      end

      def body(&blk)
        @body = blk
      end

      def run
        @execute.call
      end

      def register(app)
        app.send(method.downcase, href) do
          "hi from sinatra-schema"
        end
      end
    end

    class Definition
      attr_accessor :description, :example, :format, :type
    end

    class Resource
      attr_accessor :title, :description, :properties

      def initialize(app)
        @app = app
        @links = []
        @defs = {}
      end

      def add_definition(id)
        @defs[id] = Definition.new
        yield @defs[id]
      end

      def link(method, href, &blk)
        link = Link.new(method: method, href: href)
        yield(link)
        link.register(@app)
        @links << link
      end

      def to_schema
        {
          title: title,
          description: description
        }
      end
    end

    def self.registered(app)
      app.get "/schema" do
        MultiJson.encode(
          "$schema" => "http://json-schema.org/draft-04/hyper-schema",
          "definitions" => app.resources.inject({}) { |result, (id, resource)|
            result[id] = resource.to_schema
            result
          }
        )
      end
    end

    def resources
      @resources ||= {}
    end

    def resource(id)
      resources[id] = Resource.new(self)
      yield resources[id]
    end

  end

  register Schema
end
