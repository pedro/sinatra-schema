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

  describe '.validate_response!' do
    before { allow(resource).to receive(:properties).and_return(title: 'string') }

    it 'handles a hash response' do
      exception = assert_raises RuntimeError do
        resource.validate_response!('{}')
      end
      assert_equal 'Missing properties: ["title"]', exception.message
    end

    it 'handles an array response' do
      exception = assert_raises RuntimeError do
        resource.validate_response!('[{}]')
      end
      assert_equal 'Missing properties: ["title"]', exception.message
    end
  end
end
