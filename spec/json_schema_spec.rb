require "spec_helper"

describe Sinatra::Schema::JsonSchema do
  let(:json_schema) { described_class.new(root) }
  let(:root)        { Sinatra::Schema::Root.instance }
  let(:schema)      { json_schema.dump_root }

  describe "root level" do
    it "sets $schema" do
      assert_equal "http://json-schema.org/draft-04/hyper-schema",
        schema["$schema"]
    end

    it "adds a definition hash" do
      assert_instance_of Hash, schema["definitions"]
    end
  end
end
