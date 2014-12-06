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
            link.validate_params!(schema_params)
            res = link.action_block.call(schema_params)
            link.resource.validate_response!(res)
            res
          rescue RuntimeError => e
            halt(400)
          end
        end
      end

      def validate_params!(params)
        if properties.empty?
          if params.empty?
            return
          else
            raise "Did not expect params"
          end
        end

        Utils.validate_keys!(properties, params)
      end
    end
  end
end
