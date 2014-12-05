module Sinatra
  module Schema
    class DSL
      attr_accessor :resource

      def initialize(app, path)
        @resource = Resource.new(app: app, path: path)
      end

      def description(new_description)
        @resource.description = new_description
      end

      def define(id)
        definition = Definition.new
        resource.defs[id] = definition
      end

      def properties(properties)
        resource.properties = properties
      end

      def link(method, href="/", &blk)
        href = "#{resource.path}/#{href.chomp("/")}".chomp("/")
        link = Link.new(resource: resource, method: method, href: href)
        yield(link)
        link.register(resource.app)
        resource.links << link
      end
    end
  end
end

