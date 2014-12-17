require "active_support/inflector"
require "sinatra/base"
require "singleton"
require "multi_json"

require "sinatra/schema/definition"
require "sinatra/schema/error"
require "sinatra/schema/json_schema"
require "sinatra/schema/link"
require "sinatra/schema/param_parsing"
require "sinatra/schema/param_validation"
require "sinatra/schema/resource"
require "sinatra/schema/root"
require "sinatra/schema/utils"
require "sinatra/schema/dsl/definitions"
require "sinatra/schema/dsl/links"
require "sinatra/schema/dsl/resources"

module Sinatra
  module Schema
    def self.registered(app)
      app.helpers ParamParsing
      app.helpers ParamValidation

      app.error(Sinatra::Schema::BadRequest) do |e|
        halt(400, MultiJson.encode(error: e.message))
      end

      app.error(Sinatra::Schema::BadParams) do |e|
        halt(422, MultiJson.encode(error: e.message))
      end

      app.get "/schema" do
        content_type("application/schema+json")
        response.headers["Cache-Control"] = "public, max-age=3600"
        MultiJson.encode(JsonSchema.dump(app.schema_root), pretty: true)
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
