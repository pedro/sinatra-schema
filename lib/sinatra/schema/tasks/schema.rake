desc "Print out the JSON schema for this app"
task :schema do
  schema = Sinatra::Schema::Root.instance.to_schema
  puts MultiJson.encode(schema, pretty: true)
end
