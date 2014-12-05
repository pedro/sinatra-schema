require "spec_helper"

describe Sinatra::Schema::DSL::Resources do
  let(:app) { Sinatra::Application.new }
  let(:dsl) { described_class.new(app, "/foobar") }

  it "sets the resource description" do
    dsl.description("This is a foobar")
    assert_equal "This is a foobar", dsl.resource.description
  end

  describe "#property" do
    it "adds new properties to the resource" do
      dsl.property.text :foo
      assert_equal 1, dsl.resource.defs.size
      assert dsl.resource.defs.has_key?(:foo)
    end

    it "makes them a property of the resource" do
      dsl.property.text :foo
      assert_equal [:foo], dsl.resource.properties
    end
  end
end
