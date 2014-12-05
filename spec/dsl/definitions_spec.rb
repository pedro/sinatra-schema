require "spec_helper"

describe Sinatra::Schema::DSL::Definitions do
  let(:resource) { Sinatra::Schema::Resource.new(path: "/foobar") }
  let(:dsl)      { described_class.new(resource) }

  it "adds a string definition to the resource" do
    dsl.text(:foobar)
    assert_equal 1, resource.defs.size
    assert_equal "string", resource.defs[:foobar].type
  end
end
