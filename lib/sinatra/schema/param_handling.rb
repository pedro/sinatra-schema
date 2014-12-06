module Sinatra
  module Schema
    module ParamHandling
      def parse_params(properties)
        case request.media_type
        when nil, "application/json"
          parse_json_params
        when "application/x-www-form-urlencoded"
          cast_regular_params(properties)
        else
          raise "Cannot handle media type #{request.media_type}"
        end
      end

      def parse_json_params
        body = request.body.read
        return {} if body.length == 0 # nothing supplied

        request.body.rewind # leave it ready for other calls
        supplied_params = MultiJson.decode(body)
        unless supplied_params.is_a?(Hash)
          raise "Invalid request, expecting a hash"
        end

        indifferent_params(supplied_params)
      rescue MultiJson::ParseError
        raise "Invalid JSON"
      end

      def cast_regular_params(properties)
        casted_params = params.inject({}) do |casted, (k, v)|
          definition = properties[k.to_sym]
          # if there's no definition just leave the original param,
          # let the validation raise on this later:
          casted[k]  = definition ? definition.cast(v) : v
          casted
        end
        indifferent_params(casted_params)
      end
    end
  end
end
