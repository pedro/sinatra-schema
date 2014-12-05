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


## See also

- [sinatra-param](https://github.com/mattt/sinatra-param): nice take on validating request parameters.
