require "spec_helper"

describe Sinatra::Schema::DSL::Links do
  let(:resource) { Sinatra::Schema::Resource.new(path: "/foobar") }
  let(:dsl)      { described_class.new(options) }
  let(:options)  {{ resource: resource, method: :get, href: "/" }}

  it "sets the link title" do
    dsl.title("foo")
    assert_equal "foo", dsl.link.title
  end

  it "sets the link rel" do
    dsl.rel("foo")
    assert_equal "foo", dsl.link.rel
  end

  it "sets the link description" do
    dsl.description("Create foo")
    assert_equal "Create foo", dsl.link.description
  end

  it "sets the link action_block" do
    action = lambda { :foo }
    dsl.action(&action)
    assert_equal action, dsl.link.action_block
  end
end
