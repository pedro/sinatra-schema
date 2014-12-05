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
  end
end
