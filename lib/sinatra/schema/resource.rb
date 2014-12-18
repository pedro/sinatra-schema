module Sinatra
  module Schema
    class Resource
      attr_accessor :id, :path, :title, :defs, :links, :description, :properties

      def initialize(options)
        @path       = options.fetch(:path).chomp("/")
        @links      = []
        @defs       = {}
        @properties = {}
      end

      def id
        @id ||= path.split("/").last.to_sym
      end

      def title
        @title ||= id.to_s.capitalize
      end

      def validate_response!(rel, raw)
        # only validate responses in tests
        return unless ENV["RACK_ENV"] == "test"

        res = MultiJson.decode(raw)

        if rel == :instances
          unless res.is_a?(Array)
            raise BadResponse.new("Response should return an array")
          end
          if sample = res.first
            validate_properties!(sample)
          end
        else
          unless res.is_a?(Hash)
            raise BadResponse.new("Response should return a hash")
          end
          validate_properties!(res)
        end
      end

      def validate_properties!(received)
        missing = properties.keys.map(&:to_s).sort - received.keys.map(&:to_s).sort
        unless missing.empty?
          raise BadResponse.new("Missing properties: #{missing}")
        end

        extra = received.keys.map(&:to_s).sort - properties.keys.map(&:to_s).sort
        unless extra.empty?
          raise BadResponse.new("Unexpected properties: #{extra}")
        end

        properties.each do |id, definition|
          unless definition.valid?(received[id.to_s])
            raise BadResponse.new("Bad response property: #{id}")
          end
        end
      end
    end
  end
end
