module Sinatra
  module Schema
    class Link
      attr_accessor :action_block, :resource, :title, :description, :href, :method, :properties, :rel

      def initialize(options={})
        @resource   = options[:resource]
        @method     = options[:method]
        @href       = options[:href]
        @properties = {}
      end

      def register(app)
        app.send(method, href, &handler)
      end

      def handler
        link = self
        lambda do
          begin
            schema_params = parse_params(link.properties)
            validate_params!(schema_params, link.properties)
            res = instance_exec(schema_params, &link.action_block)
            link.resource.validate_response!(link.rel, res)
            res
          end
        end
      end
    end
  end
end
