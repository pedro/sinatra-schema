require "test_helper"

describe SinatraSchemeTest do
  it "still works as a regular sinatra app" do
    get "/regular"
    assert_equal 200, last_response.status
    assert_equal "hi", last_response.body
  end

  it "support resource links" do
    get "/accounts"
    assert_equal 200, last_response.status
    assert_equal({ "email" => "foo" },
        MultiJson.decode(last_response.body))
  end

  it "exposes the json schema" do
    get "/schema"
    assert_equal 200, last_response.status
    schema = MultiJson.decode(last_response.body)
    assert_equal "http://json-schema.org/draft-04/hyper-schema",
      schema["$schema"]
    assert_equal Hash, schema["definitions"].class
    assert_equal Hash, schema["definitions"]["account"].class
    assert_equal "Account", schema["definitions"]["account"]["title"]
    assert_equal "An account represents an individual signed up to use the Heroku platform.",
      schema["definitions"]["account"]["description"]
  end
end
