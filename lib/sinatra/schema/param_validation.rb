module Sinatra
  module Schema
    module ParamValidation
      def validate_params!(params, properties)
        missing = properties.keys.map(&:to_s).sort - params.keys.map(&:to_s).sort
        unless missing.empty?
          raise "Missing properties: #{missing}"
        end

        extra = params.keys.map(&:to_s).sort - properties.keys.map(&:to_s).sort
        unless extra.empty?
          raise "Unexpected properties: #{extra}"
        end

        properties.each do |id, definition|
          unless definition.valid?(params[id])
            raise "Bad param: #{id}"
          end
        end
      end
    end
  end
end
