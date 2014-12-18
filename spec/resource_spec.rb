require "spec_helper"

describe Sinatra::Schema::Resource do
  let(:resource) { Sinatra::Schema::Resource.new(path: "/artists") }

  describe "#id" do
    it "is inferred from the path" do
      assert_equal :artists, resource.id
    end
  end

  describe "#title" do
    it "is inferred from the path" do
      assert_equal "Artists", resource.title
    end
  end

  describe "#validate_response!" do
    before do
      resource.properties[:email] = Sinatra::Schema::Definition.new(type: "email")
    end

    describe "instances rel" do
      it "ensures the response is an array" do
        assert_raises Sinatra::Schema::BadResponse do
          resource.validate_response!(:instances, "{}")
        end
      end

      it "allows empty responses" do
        resource.validate_response!(:instances, "[]")
      end

      it "validates the first element when available" do
        res = MultiJson.encode([ { email: "foo@bar.com" } ])
        resource.validate_response!(:instances, res)
      end

      it "raises when response has a missing property" do
        res = MultiJson.encode([ {} ])
        assert_raises Sinatra::Schema::BadResponse do
          resource.validate_response!(:instances, res)
        end
      end

      it "raises when response has an extra property" do
        res = MultiJson.encode([ { email: "foo@bar.com", other: true } ])
        assert_raises Sinatra::Schema::BadResponse do
          resource.validate_response!(:instances, res)
        end
      end
    end

    describe "self/other rel" do
      it "ensures the response is a hash" do
        assert_raises Sinatra::Schema::BadResponse do
          resource.validate_response!(:self, "[]")
        end
      end

      it "raises when response has a missing property" do
        assert_raises Sinatra::Schema::BadResponse do
          resource.validate_response!(:self, "{}")
        end
      end

      it "raises when response has an extra property" do
        res = MultiJson.encode(email: "foo@bar.com", other: true)
        assert_raises Sinatra::Schema::BadResponse do
          resource.validate_response!(:self, res)
        end
      end
    end
  end
end
