module Sinatra
  module Schema
    module ParamValidation
      def validate_params!(params, properties)
        required_properties = properties.map do |k, prop|
          # ignore nested properties for now, we'll cover these next
          k unless prop.is_a?(Hash) || prop.optional
        end.compact

        missing = required_properties.map(&:to_s).sort - params.keys.map(&:to_s).sort
        unless missing.empty?
          raise BadParams.new("Missing expected params: #{missing.join(',')}")
        end

        extra = params.keys.map(&:to_s).sort - properties.keys.map(&:to_s).sort
        unless extra.empty?
          raise BadParams.new("Unexpected params: #{extra.join(',')}")
        end

        properties.each do |id, definition|
          # handle nested params
          if definition.is_a?(Hash)
            validate_params!(params[id], definition)
          else
            unless definition.valid?(params[id])
              raise BadParams.new("Incorrect format for param '#{id}'. Please encode it as #{definition.type}")
            end
          end
        end
      end
    end
  end
end
