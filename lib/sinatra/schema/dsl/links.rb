module Sinatra
  module Schema
    module DSL
      class Links
        attr_accessor :href, :link, :method, :resource

        def initialize(options)
          @href     = options.fetch(:href)
          @method   = options.fetch(:method)
          @resource = options.fetch(:resource)
          @link     = build_link
        end

        def title(title)
          link.title = title
        end

        def rel(rel)
          link.rel = rel
        end

        def description(description)
          link.description = description
        end

        def action(&blk)
          link.action_block = blk
        end

        def property
          DSL::Definitions.new(resource, [resource.defs, link.properties])
        end

        protected

        def build_link
          full_href = "#{resource.path}/#{href}".gsub("//", "/").chomp("/")
          Link.new(resource: resource, method: method, href: full_href)
        end
      end
    end
  end
end
