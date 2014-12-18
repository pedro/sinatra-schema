require "spec_helper"

describe Sinatra::Schema::DSL::Definitions do
  let(:resource) { Sinatra::Schema::Resource.new(path: "/foobar") }
  let(:dsl)      { described_class.new(resource, [resource.defs, resource.properties]) }
  let(:root)     { Sinatra::Schema::Root.instance }

  it "adds a string definition to the resource" do
    dsl.text(:foobar)
    assert_equal 1, resource.defs.size
    assert_equal "string", resource.defs[:foobar].type
  end

  it "adds a boolean definition to the resource" do
    dsl.bool(:foobar)
    assert_equal 1, resource.defs.size
    assert_equal "boolean", resource.defs[:foobar].type
  end

  it "adds a datetime definition to the resource" do
    dsl.datetime(:foobar)
    assert_equal 1, resource.defs.size
    assert_equal "datetime", resource.defs[:foobar].type
  end

  it "adds nested definitions" do
    dsl[:user].text :email
    dsl[:user].bool :admin
    assert_equal 2, resource.defs[:user].size
    assert_equal "string", resource.defs[:user][:email].type
    assert_equal "boolean", resource.defs[:user][:admin].type
  end

  it "adds references" do
    dsl.ref(:another_property)
    assert_equal 1, resource.defs.size
    assert_instance_of Sinatra::Schema::Reference, resource.defs[:another_property]
  end

  it "sets other options" do
    dsl.text(:foobar, optional: true)
    assert_equal true, resource.defs[:foobar].optional
  end
end
