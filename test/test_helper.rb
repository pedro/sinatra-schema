ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler'

Bundler.require(:default, :test)

require 'minitest/spec'
require 'minitest/autorun'
require 'sinatra'
require './app'

class MiniTest::Spec
  include Rack::Test::Methods

  def app
    SinatraSchemeTest
  end
end
