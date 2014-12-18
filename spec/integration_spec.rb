require "spec_helper"

describe Sinatra::Schema do
  describe "resource access" do
    it "still works as a regular sinatra app" do
      get "/regular"
      assert_equal 200, last_response.status
      assert_equal "hi", last_response.body
    end

    it "support resource gets" do
      get "/accounts"
      assert_equal 200, last_response.status
      assert_equal({ "email" => "foo@bar.com" },
        MultiJson.decode(last_response.body))
    end

    it "support resource posts" do
      post "/accounts", email: "foo@baz.com"
      assert_equal 200, last_response.status
      assert_equal({ "email" => "foo@baz.com" },
        MultiJson.decode(last_response.body))
    end
  end

  describe "GET /schema" do
    before do
      get "/schema"
      @schema = MultiJson.decode(last_response.body)
    end

    it "renders a 200" do
      assert_equal 200, last_response.status
    end

    it "sets the appropriate content-type" do
      assert_equal "application/schema+json",
        last_response.headers["Content-Type"]
    end

    it "sets $schema to hyper-schema" do
      assert_equal "http://json-schema.org/draft-04/hyper-schema",
        @schema["$schema"]
    end

    it "generates definitions" do
      assert_equal Hash, @schema["definitions"].class
      assert_equal Hash, @schema["definitions"]["accounts"].class
      assert_equal "Accounts", @schema["definitions"]["accounts"]["title"]
      assert_equal "An account represents an individual signed up to use the service",
        @schema["definitions"]["accounts"]["description"]
    end
  end

  describe "error handling" do
    before do
      header "Content-Type", "application/json"
    end

    it "converts BadRequest into a 400" do
      post "/accounts", "{"
      assert_equal 400, last_response.status
      assert_equal({ "error" => "Invalid JSON encoded in request" }, last_json)
    end

    it "converts BadParams into a 422" do
      post "/accounts", "{}"
      assert_equal 422, last_response.status
      assert_equal({ "error" => "Missing expected params: email" }, last_json)
    end
  end
end
