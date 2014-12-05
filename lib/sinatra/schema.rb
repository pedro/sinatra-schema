module Sinatra
  module Schema
    class Link
      attr_accessor :resource, :title, :description, :href, :method, :properties, :rel, :action

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
          begin
            link.validate_params!(params)
            res = link.action_block.call(params)
            link.resource.validate_response!(res)
            MultiJson.encode(res)
          rescue RuntimeError => e
            halt(400)
          end
        end
      end

      def validate_params!(params)
        unless properties
          if params.empty?
            return
          else
            raise "Did not expect params"
          end
        end

        Utils.validate_keys!(properties, params)
      end
    end

    class Definition
      attr_accessor :description, :example, :format, :type
    end

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

        Utils.validate_keys!(properties, res)
      end

      def to_schema
        {
          title: title,
          description: description
        }
      end
    end

    class Utils
      def self.validate_keys!(expected, received)
        missing = expected.map(&:to_s).sort - received.keys.map(&:to_s).sort
        unless missing.empty?
          raise "Missing properties: #{missing}"
        end

        extra = received.keys.map(&:to_s).sort - expected.map(&:to_s).sort
        unless extra.empty?
          raise "Unexpected properties: #{extra}"
        end
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
