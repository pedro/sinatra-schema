# Sinatra Schema

Define a schema for your Sinatra application to get requests and responses validated. Dump it schema as a JSON Schema to aid client generation and more!


## Usage

Register `Sinatra::Schema` and define resources like:

```ruby
class MyApi < Sinatra::Base
  register Sinatra::Schema

  resource("/artists") do
    description "A film artist like Nicolas Cage or Meryl Streep"

    res.link(:post) do
      title "Create"
      description "Add artist"
      action do
        Artist.create(email: params[:email])
      end
    end
  end
end
```


## Context

There are [lots of reasons why you should consider describe your API with a machine-readable format](http://pedro.by4am.com/past/2014/5/23/get_more_out_of_your_service_with_machinereadable_api_specs/):

- Describe what endpoints are available
- Validate requests and responses
- Embrace constraints to make sure your API design is consistent
- Generate documentation
- Generate clients
- Generate service stubs

Sinatra Schema is a thin layer on top of JSON Schema, trying to bring all of the benefits without any of the JSON.

If you need more flexibility, or if you think the schema should live by itself, then you should consider writing the schema yourself. Tools like [prmd](https://github.com/interagent/prmd) can really help you get started, and [committee](https://github.com/interagent/committee) can help you get benefits out of that schema.


## Meta

Created by Pedro Belo. MIT license.
