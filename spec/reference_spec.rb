require "spec_helper"

describe Sinatra::Schema::Reference do
  let(:resource) { Sinatra::Schema::Root.instance.resources[:accounts] }
  let(:ref) { described_class.new(resource, :foo, :email) }
  let(:definition) { resource.defs[:email] }

  describe "#resolve!" do
    it "finds other properties in the same resource" do
      ref.ref_spec = :foo
      resource.defs[:foo] = definition
      assert_equal definition, ref.resolve!
    end

    it "finds other properties elsewhere in the schema" do
      ref.ref_spec = "accounts/email"
      assert_equal definition, ref.resolve!
    end

    it "raises when it cannot resolve" do
      ref.ref_spec = "does-not-exist"
      assert_raises(Sinatra::Schema::BadReference) do
        ref.resolve!
      end
    end
  end

  describe "delegated attributes" do
    it "#cast" do
      assert_equal definition.cast("foo"), ref.cast("foo")
    end

    it "#description" do
      assert_equal definition.description, ref.description
    end

    it "#example" do
      assert_equal definition.example, ref.example
    end

    it "#optional" do
      assert_equal definition.optional, ref.optional
    end

    it "#type" do
      assert_equal definition.type, ref.type
    end

    it "#valid?" do
      assert_equal definition.valid?("foo"), ref.valid?("foo")
    end
  end
end
