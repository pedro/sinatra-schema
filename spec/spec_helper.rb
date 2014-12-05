ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler'

Bundler.require(:default, :test)

require 'sinatra'
require './app'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.expect_with :minitest

  def app
    SinatraSchemeTest
  end
end
