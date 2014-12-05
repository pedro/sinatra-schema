require "active_support/inflector"
require "sinatra"
require "singleton"
require "multi_json"

require "sinatra/schema/definition"
require "sinatra/schema/link"
require "sinatra/schema/resource"
require "sinatra/schema/root"
require "sinatra/schema/utils"

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
      Sinatra::Schema::Root.instance
    end

    def resource(path)
      res  = Resource.new(app: self, path: path)
      yield(res)
      schema_root.add_resource(res)
    end
  end

  register Schema
end
