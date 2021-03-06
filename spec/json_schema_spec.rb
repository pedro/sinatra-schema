require "spec_helper"

describe Sinatra::Schema::JsonSchema do
  let(:json_schema) { described_class.new(root) }
  let(:root)        { Sinatra::Schema::Root.instance }
  let(:schema)      { json_schema.dump_root }

  describe "#dump_root" do
    it "sets $schema" do
      assert_equal "http://json-schema.org/draft-04/hyper-schema",
        schema["$schema"]
    end

    it "adds a definition hash" do
      assert_instance_of Hash, schema["definitions"]
    end
  end

  describe "#dump_definition" do
    let(:definition) { Sinatra::Schema::Definition.new }

    it "handles simple string format" do
      definition.type = "string"
      schema = json_schema.dump_definition(definition)
      assert_equal "string", schema[:type]
      assert_nil schema[:format]
    end

    it "handles the datetime format" do
      definition.type = "datetime"
      schema = json_schema.dump_definition(definition)
      assert_equal "string", schema[:type]
      assert_equal "date-time", schema[:format]
    end

    it "handles the email format" do
      definition.type = "email"
      schema = json_schema.dump_definition(definition)
      assert_equal "string", schema[:type]
      assert_equal "email", schema[:format]
    end

    it "handles the integer format" do
      definition.type = "integer"
      schema = json_schema.dump_definition(definition)
      assert_equal "integer", schema[:type]
    end

    it "handles the uuid format" do
      definition.type = "uuid"
      schema = json_schema.dump_definition(definition)
      assert_equal "string", schema[:type]
      assert_equal "uuid", schema[:format]
    end
  end

  describe "#dump_link" do
    let(:resource) { Sinatra::Schema::Resource.new(path: "/foo") }
    let(:link)     { Sinatra::Schema::Link.new(resource: resource, href: "/") }

    it "renders the method in upcase" do
      link.method = :get
      schema = json_schema.dump_link(link)
      assert_equal "GET", schema[:method]
    end

    it "appends the resource path to href" do
      schema = json_schema.dump_link(link)
      assert_equal "/foo", schema[:href]
    end

    it "formats the href with URI template" do
      link.href = "/:id"
      schema = json_schema.dump_link(link)
      assert_equal "/foo/{id}", schema[:href]
    end
  end
end
