require "spec_helper"

describe Sinatra::Schema do
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
    post "/accounts", email: "omg"
    assert_equal 200, last_response.status
    assert_equal({ "email" => "omg" },
      MultiJson.decode(last_response.body))
  end

  describe "error handling" do
    it "converts BadParams into a 400" do
      post "/accounts", foo: "bar"
      assert_equal 400, last_response.status
      assert_equal({ "error" => "Missing expected params: email" }, last_json)
    end
  end
end
