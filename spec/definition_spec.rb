require "spec_helper"

describe Sinatra::Schema::Definition do
  let(:definition) { Sinatra::Schema::Definition.new }

  describe "#cast" do
    it "casts booleans" do
      definition.type = "boolean"
      assert_equal true, definition.cast("t")
      assert_equal true, definition.cast("true")
      assert_equal true, definition.cast("1")
      assert_equal false, definition.cast("0")
      assert_equal false, definition.cast("false")
    end

    it "casts text" do
      definition.type = "string"
      assert_equal "123", definition.cast(123)
    end
  end

  describe "#valid?" do
    it "detects booleans" do
      definition.type = "boolean"
      assert definition.valid?(true)
      assert definition.valid?(false)
      refute definition.valid?("true")
    end

    it "detects text" do
      definition.type = "string"
      assert definition.valid?("foo")
      refute definition.valid?(123)
    end
  end
end
