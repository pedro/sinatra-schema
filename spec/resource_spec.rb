require "spec_helper"

describe Sinatra::Schema::Resource do
  let(:resource) { Sinatra::Schema::Resource.new(path: "/artists") }

  describe "#id" do
    it "is inferred from the path" do
      assert_equal :artist, resource.id
    end
  end

  describe "#title" do
    it "is inferred from the path" do
      assert_equal "Artist", resource.title
    end
  end
end
