module Sinatra
  module Schema
    module DSL
      class Resources
        attr_accessor :app, :resource

        def initialize(app, path)
          @app      = app
          @resource = Resource.new(path: path)
        end

        def description(description)
          @resource.description = description
        end

        def property
          DSL::Definitions.new(resource)
        end

        def properties(properties)
          resource.properties = properties
        end

        def link(method, href="/", &blk)
          dsl = DSL::Links.new(resource: resource, method: method, href: href)
          blk.call(dsl)
          link = dsl.link
          link.register(app)
          resource.links << link
        end
      end
    end
  end
end
