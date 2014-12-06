module Sinatra
  module Schema
    class Link
      attr_accessor :action_block, :resource, :title, :description, :href, :method, :properties, :rel

      def initialize(options)
        @resource   = options[:resource]
        @method     = options[:method]
        @href       = options[:href]
        @properties = {}
      end

      def register(app)
        link = self
        app.send(method.downcase, href) do
          begin
            schema_params = parse_params(link.properties)
            validate_params!(schema_params, link.properties)
            res = link.action_block.call(schema_params)
            link.resource.validate_response!(res)
            res
          rescue RuntimeError => e
            halt(400)
          end
        end
      end
    end
  end
end
