require "spec_helper"

describe Sinatra::Schema do
  it "still works as a regular sinatra app" do
    get "/regular"
    assert_equal 200, last_response.status
    assert_equal "hi", last_response.body
  end

  it "support resource links" do
    get "/accounts"
    assert_equal 200, last_response.status
    assert_equal({ "email" => "foo@bar.com" },
      MultiJson.decode(last_response.body))
  end

  it "support resource links" do
    post "/accounts", email: "omg"
    assert_equal 200, last_response.status
    assert_equal({ "email" => "omg" },
      MultiJson.decode(last_response.body))
  end

  it "validates input" do
    post "/accounts", foo: "bar"
    assert_equal 400, last_response.status
  end
end
