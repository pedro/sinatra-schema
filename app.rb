require "sinatra"
require "./lib/sinatra/schema"

class SinatraSchemeTest < Sinatra::Base
  register Sinatra::Schema

  get "/regular" do
    "hi"
  end

  resource(:account) do |res|
    res.title = "Account"
    res.description = "An account represents an individual signed up to use the Heroku platform."

    res.add_definition(:email) do |d|
      d.description = "unique email address of account"
      d.example = "username@example.com"
      d.format = "email"
      d.type = :string
    end

    res.properties = [:email]

    res.link(:get, "/account") do |link|
      link.title = "Info"
      link.rel = "self"
      link.description = "Info for account."
      link.body do
        # ...
      end
    end
  end
end
