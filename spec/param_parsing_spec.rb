require "spec_helper"

describe Sinatra::Schema::ParamParsing do
  before do
    @rack_app = Sinatra.new do
      helpers Sinatra::Schema::ParamParsing
      post("/") do
        MultiJson.encode(parse_params($properties))
      end
    end
  end

  describe "JSON encoded request params" do
    before do
      header "Content-Type", "application/json"
    end

    it "handles invalid json" do
      assert_raises(RuntimeError, "Invalid JSON") do
        post "/", "{"
      end
    end

    it "considers an empty body an empty hash" do
      post "/", ""
      assert_equal Hash.new, last_json
    end

    it "just parses the json" do
      params = { "foo" => "bar", "baz" => 42 }
      post "/", MultiJson.encode(params)
      assert_equal params, last_json
    end

    it "preserves nested params" do
      params = { "foo" => { "bar" => 42 }}
      post "/", MultiJson.encode(params)
      assert_equal params, last_json
    end
  end

  describe "form-encoded params" do
    it "casts values according to the schema" do
      $properties = {
        some_text: Sinatra::Schema::Definition.new(type: "string"),
        some_bool: Sinatra::Schema::Definition.new(type: "boolean"),
      }
      post "/", some_text: "true", some_bool: "true"
      assert_equal({ "some_text" => "true", "some_bool" => true }, last_json)
    end

    it "handles nested params" do
      $properties = {
        foo: { bar: Sinatra::Schema::Definition.new(type: "boolean") }
      }
      post "/", foo: { bar: "true" }
      assert_equal({ "foo" => { "bar" => true }}, last_json)
    end

    it "leaves params without the corresponding property untouched" do
      $properties = {}
      params = { "foo" => "bar" }
      post "/", params
      assert_equal params, last_json
    end

    it "leaves null params" do
      $properties = { bool: Sinatra::Schema::Definition.new(type: "boolean") }
      params = { "bool" => nil }
      post "/", params
      assert_equal params, last_json
    end
  end

  it "errors out on other formats" do
    assert_raises(RuntimeError, "Cannot handle media type application/xml") do
      header "Content-Type", "application/xml"
      post "/", "<omg />"
    end
  end
end
