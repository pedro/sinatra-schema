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

    it "detects emails" do
      definition.type = "email"
      assert definition.valid?("foo@bar.com")
      refute definition.valid?("foobar.com")
    end

    it "detects text" do
      definition.type = "string"
      assert definition.valid?("foo")
      refute definition.valid?(123)
    end

    it "detects uuids" do
      definition.type = "uuid"
      assert definition.valid?(SecureRandom.uuid)
      refute definition.valid?("wrong")
    end
  end

  describe "#to_schema" do
    it "dumps emails" do
      definition.type = "email"
      schema = definition.to_schema
      assert_equal "string", schema[:type]
      assert_equal "email", schema[:format]
    end

    it "dumps uuids" do
      definition.type = "uuid"
      schema = definition.to_schema
      assert_equal "string", schema[:type]
      assert_equal "uuid", schema[:format]
    end
  end
end
