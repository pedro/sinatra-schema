require "sinatra"
require "multi_json"

require "sinatra/schema/definition"
require "sinatra/schema/link"
require "sinatra/schema/resource"
require "sinatra/schema/utils"

module Sinatra
  module Schema
    def self.registered(app)
      app.get "/schema" do
        MultiJson.encode(
          "$schema" => "http://json-schema.org/draft-04/hyper-schema",
          "definitions" => app.resources.inject({}) { |result, (id, resource)|
            result[id] = resource.to_schema
            result
          }
        )
      end
    end

    def resources
      @resources ||= {}
    end

    def resource(path)
      res = Resource.new(self, path)
      yield(res)
      resources[res.id] = res
    end

  end

  register Schema
end
