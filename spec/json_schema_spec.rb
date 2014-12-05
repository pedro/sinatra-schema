require "spec_helper"

describe "JSON Schema" do
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
    assert_equal Hash, @schema["definitions"]["account"].class
    assert_equal "Account", @schema["definitions"]["account"]["title"]
    assert_equal "An account represents an individual signed up to use the service",
      @schema["definitions"]["account"]["description"]
  end
end
