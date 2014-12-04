module Sinatra
  module Schema
    class Link
      attr_accessor :resource, :title, :description, :href, :method, :rel, :action

      def initialize(options)
        @resource = options[:resource]
        @method   = options[:method]
        @href     = options[:href]
      end

      def action(&blk)
        @action = blk
      end

      def action_block
        @action
      end

      def register(app)
        link = self
        app.send(method.downcase, href) do
          res = link.action_block.call
          serialized = link.resource.serialize(res)
          link.resource.validate_response!(serialized)
          MultiJson.encode(serialized)
        end
      end
    end

    class Definition
      attr_accessor :description, :example, :format, :type
    end

    class Resource
      attr_accessor :id, :path, :title, :description, :properties, :serializer

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
          raise "Serializer should return a hash"
        end

        missing = properties.map(&:to_s).sort - res.keys.map(&:to_s).sort
        unless missing.empty?
          raise "Missing properties: #{missing}"
        end

        extra = res.keys.map(&:to_s).sort - properties.map(&:to_s).sort
        unless extra.empty?
          raise "Unexpected properties: #{extra}"
        end
      end

      def serialize(response)
        serializer.call(response)
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

    def resource(path)
      res = Resource.new(self, path)
      yield(res)
      resources[res.id] = res
    end

  end

  register Schema
end
