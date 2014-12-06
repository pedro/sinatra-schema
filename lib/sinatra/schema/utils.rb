module Sinatra
  module Schema
    class Utils
      def self.validate_keys!(properties, received)
        missing = properties.keys.map(&:to_s).sort - received.keys.map(&:to_s).sort
        unless missing.empty?
          raise "Missing properties: #{missing}"
        end

        extra = received.keys.map(&:to_s).sort - properties.keys.map(&:to_s).sort
        unless extra.empty?
          raise "Unexpected properties: #{extra}"
        end

        properties.each do |id, definition|
          unless definition.valid?(received[id.to_s])
            raise "Bad response property: #{id}"
          end
        end
      end
    end
  end
end
