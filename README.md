# Sinatra Schema

Define a schema for your Sinatra application to get requests and responses validates. Dump it schema as a JSON Schema to aid client generation and more!


## Usage

Register `Sinatra::Schema` and define resources like:

```ruby
class MyApi < Sinatra::Base
  register Sinatra::Schema

  resource("/accounts") do
    title "Account"
    description "The account of a user signed up to our service"
    serializer AccountSerializer

    res.link(:post) do
      title "Create"
      description "Create a new account"
      action do
        Account.create(email: params[:email])
      end
    end
  end
end
```


## See also

- [sinatra-param](https://github.com/mattt/sinatra-param): nice take on validating request parameters.
