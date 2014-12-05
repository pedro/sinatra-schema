ENV["RACK_ENV"] = "test"

require "rubygems"
require "bundler"

Bundler.require

require "rack/test"
require "sinatra"
require "sinatra/schema"

Dir["./spec/support/*"].each { |f| require(f) }

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.expect_with :minitest

  def app
    TestApp
  end
end
