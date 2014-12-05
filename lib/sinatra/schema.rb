require "active_support/inflector"
require "sinatra"
require "singleton"
require "multi_json"

require "sinatra/schema/definition"
require "sinatra/schema/link"
require "sinatra/schema/resource"
require "sinatra/schema/root"
require "sinatra/schema/utils"
require "sinatra/schema/dsl/definitions"
require "sinatra/schema/dsl/links"
require "sinatra/schema/dsl/resources"

module Sinatra
  module Schema
    def self.registered(app)
      app.get "/schema" do
        content_type("application/schema+json")
        response.headers["Cache-Control"] = "public, max-age=3600"
        MultiJson.encode(
          "$schema" => "http://json-schema.org/draft-04/hyper-schema",
          "definitions" => app.schema_root.resources.inject({}) { |result, (id, resource)|
            result[id] = resource.to_schema
            result
          }
        )
      end
    end

    def schema_root
      Root.instance
    end

    def resource(path)
      spec = DSL::Resources.new(self, path)
      yield(spec)
      schema_root.add_resource(spec.resource)
    end
  end

  register Schema
end
