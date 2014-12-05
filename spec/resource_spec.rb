require "spec_helper"

describe Sinatra::Schema::Resource do
  let(:app)      { Sinatra.new }
  let(:options)  {{ app: app, path: "/artists" }}
  let(:resource) { Sinatra::Schema::Resource.new(options) }

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
