module Sinatra
  module Schema
    module DSL
      class Resources
        attr_accessor :app, :resource

        def initialize(app, path_or_id)
          @app = app
          if path_or_id.is_a?(Symbol)
            @resource = Resource.new(id: path_or_id)
          else
            @resource = Resource.new(path: path_or_id)
          end
        end

        def description(description)
          @resource.description = description
        end

        def id(id)
          @resource.id = id.to_sym
        end

        def title(title)
          @resource.title = title
        end

        def property
          DSL::Definitions.new(resource, [resource.defs, resource.properties])
        end

        def delete(href="/", &blk)
          build_link(:delete, href, &blk)
        end

        def get(href="/", &blk)
          build_link(:get, href, &blk)
        end

        def patch(href="/", &blk)
          build_link(:patch, href, &blk)
        end

        def post(href="/", &blk)
          build_link(:post, href, &blk)
        end

        def put(href="/", &blk)
          build_link(:put, href, &blk)
        end

        protected

        def build_link(method, href="/", &blk)
          dsl = DSL::Links.new(resource: resource, method: method, href: href)
          blk.call(dsl) if blk
          dsl.link.tap do |link|
            link.register(app)
            resource.links << link
          end
        end
      end
    end
  end
end
