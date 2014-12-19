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

    it "casts datetime" do
      definition.type = "datetime"
      t = definition.cast("2014-05-01T12:13:14.15Z")
      assert_equal 2014, t.year
      assert_equal 5, t.month
      assert_equal 1, t.day
      assert_equal 12, t.hour
      assert_equal 13, t.min
      assert_equal 14, t.sec
      assert_equal 150000, t.usec
      assert_equal "UTC", t.zone
    end

    it "casts integers" do
      definition.type = "integer"
      assert_equal 42, definition.cast("42")
    end

    it "casts text" do
      definition.type = "string"
      assert_equal "123", definition.cast(123)
    end
  end

  describe "#valid?" do
    it "validates booleans" do
      definition.type = "boolean"
      assert definition.valid?(true)
      assert definition.valid?(false)
      refute definition.valid?("true")
    end

    it "validates emails" do
      definition.type = "email"
      assert definition.valid?("foo@bar.com")
      refute definition.valid?("foobar.com")
    end

    it "validates integers" do
      definition.type = "integer"
      assert definition.valid?(42)
      refute definition.valid?("42omg")
    end

    it "validates objects" do
      definition.type = "object"
      assert definition.valid?(good: true)
      refute definition.valid?("bad")
    end

    it "validates text" do
      definition.type = "string"
      assert definition.valid?("foo")
      refute definition.valid?(123)
    end

    it "validates uuids" do
      definition.type = "uuid"
      assert definition.valid?(SecureRandom.uuid)
      refute definition.valid?("wrong")
    end

    it "validates date+time fields" do
      definition.type = "datetime"
      assert definition.valid?("1985-04-12T23:20:50.52Z")
      refute definition.valid?("12/4/1985 23:20:50")
    end
  end
end
