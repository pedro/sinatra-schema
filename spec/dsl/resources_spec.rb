require "spec_helper"

describe Sinatra::Schema::DSL::Resources do
  let(:app) { Sinatra.new {} }
  let(:dsl) { described_class.new(app, "/foobar") }

  it "sets the resource description" do
    dsl.description("This is a foobar")
    assert_equal "This is a foobar", dsl.resource.description
  end

  it "sets the id casting to symbol" do
    dsl.id("account")
    assert_equal :account, dsl.resource.id
  end

  describe "#property" do
    it "adds new definitions to the resource" do
      dsl.property.text :foo
      assert_equal 1, dsl.resource.defs.size
      assert dsl.resource.defs.has_key?(:foo)
    end

    it "makes them a property of the resource" do
      dsl.property.text :foo
      assert_equal 1, dsl.resource.properties.size
      assert dsl.resource.properties.has_key?(:foo)
    end

    it "supports nested properties" do
      dsl.property[:user].text :email
      dsl.property[:user].bool :admin
      assert_equal 2, dsl.resource.properties[:user].size
    end
  end

  describe "building links" do
    it "builds a DELETE" do
      link = dsl.delete
      assert_equal :delete, link.method
    end

    it "builds a GET" do
      link = dsl.get
      assert_equal :get, link.method
    end

    it "builds a PATCH" do
      link = dsl.patch
      assert_equal :patch, link.method
    end

    it "builds a POST" do
      link = dsl.post
      assert_equal :post, link.method
    end

    it "builds a PUT" do
      link = dsl.put
      assert_equal :put, link.method
    end
  end
end
