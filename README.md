# Sinatra Schema

Define a schema for your Sinatra application to get requests and responses validated. Dump it schema as a JSON Schema to aid client generation and more!

**Under design**. The reference below might be outdated – please check specs to see the latest.


## Usage

Register `Sinatra::Schema` to define your resource like:

```ruby
class MyApi < Sinatra::Base
  register Sinatra::Schema

  resource("/account") do |res|
    # every link below should serialize according to this:
    res.property.text :email

    res.link(:get) do |link|
      link.action do
        # Sinatra::Schema will render this to json:
        { email: current_user.email }
      end
    end
  end
end
```

### Declare params

Links can have properties too:

```ruby
resource("/account") do |res|
  # every link below should serialize according to this:
  res.property.text :email

  res.link(:post) do |link|
    link.property.ref :email # point to the property linked above
    link.property.boolean :admin, optional: true

    link.action do
      User.create(email: params[:email])
    end
  end
```

### Cross-resource params

Reuse properties from other resources when appropriate:

```ruby
resource("/artists") do
  res.property.text :name, description: "Artist name"
end

resource("/albums") do
  rest.property.text :name, description: "Album name"
  res.property.ref :artist_name, "artists/name"
end
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
