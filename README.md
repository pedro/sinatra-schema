# Sinatra Schema

[![Gem version](http://img.shields.io/gem/v/sinatra-schema.svg)](https://rubygems.org/gems/sinatra-schema)
[![Build Status](https://travis-ci.org/pedro/sinatra-schema.svg?branch=master)](https://travis-ci.org/pedro/sinatra-schema)

Define a schema for your Sinatra application to get requests and responses validated. Dump it schema as a JSON Schema to aid client generation and more!

**Under design**. The reference below might be outdated – please check specs to see the latest.


## Usage

Register `Sinatra::Schema` to define your resource like:

```ruby
class MyApi < Sinatra::Base
  register Sinatra::Schema

  resource("/account") do |res|
    res.property.text :email

    res.link(:get) do |link|
      link.action do
        # note per definition above we need to serialize "email"
        MultiJson.encode(email: current_user.email)
      end
    end
  end
end
```

### Params

Links can have properties too:

```ruby
resource("/account") do |res|
  res.property.text :email

  res.link(:post) do |link|
    link.property.ref  :email # reuse the property defined above
    link.property.bool :admin

    link.action do |params|
      user = User.new(email: params[:email])
      if params[:admin] # params are casted accordingly!
        # ...
      end
    end
  end
```

### Cross-resource params

Reuse properties from other resources when appropriate:

```ruby
resource("/artists") do |res|
  res.property.text :name, description: "Artist name"
end

resource("/albums") do |res|
  res.property.text :name, description: "Album name"
  res.property.ref :artist_name, "artists/name"
end
```

### Nested params

These are also casted and validated as you'd expect:

```ruby
resource("/albums") do |res|
  resource.link(:post) do |link|
    link.nested :artist do |a|
      a.property.text :name
    end
  end
end
```

### JSON Schema

The extension will serve a JSON Schema dump at `GET /schema` for you.

You can also include the `schema` Rake task to print it out. To do so, add to your `Rakefile`:

```ruby
require "./app" # load your app to have the endpoints defined
load "sinatra/schema/tasks/schema.rake"
```

Then dump it like:

```
$ rake schema
{
  "$schema":"http://json-schema.org/draft-04/hyper-schema",
  "definitions":{
    "account":{
      "title":"Account",
      "type":"object",
      "definitions":{
        "email":{
          "type":"string"
        }
      },
      "links":[
        {
          "href":"/account",
          "method":"GET"
        }
      ]
    }
  }
}
```


## Context

There are [lots of reasons why you should consider describe your API with a machine-readable format](http://pedro.by4am.com/past/2014/5/23/get_more_out_of_your_service_with_machinereadable_api_specs/):

- Describe what endpoints are available
- Validate requests and responses
- Embrace constraints for consistent API design
- Generate documentation
- Generate clients
- Generate service stubs

Sinatra Schema is a thin layer on top of JSON Schema, trying to bring all of the benefits without any of the JSON.

If you need more flexibility, or if you think the schema should live by itself, then you should consider writing the schema yourself. Tools like [prmd](https://github.com/interagent/prmd) can really help you get started, and [committee](https://github.com/interagent/committee) can help you get benefits out of that schema.


## Meta

Created by Pedro Belo. MIT license.
