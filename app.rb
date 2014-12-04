require "sinatra"
require "./lib/sinatra/schema"

class SinatraSchemeTest < Sinatra::Base
  register Sinatra::Schema

  get "/regular" do
    "hi"
  end

  resource("/accounts") do |res|
    res.id = :account
    res.title = "Account"
    res.description = "An account represents an individual signed up to use the Heroku platform."

    res.define(:email) do |d|
      d.description = "unique email address of account"
      d.example = "username@example.com"
      d.format = "email"
      d.type = :string
    end

    res.properties = [:email]
    res.serializer = lambda { |x| { email: x }}

    res.link(:get) do |link|
      link.title = "Info"
      link.rel = "self"
      link.description = "Info for account"
      link.action do
        "foo@bar.com"
      end
    end

    res.link(:post) do |link|
      link.title = "Create"
      link.rel = "create"
      link.description = "Create a new account"
      link.properties = [:email]
      link.action do |params|
        params[:email]
      end
    end
  end
end
