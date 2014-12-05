$:.unshift File.expand_path("../lib", __FILE__)
require "sinatra/schema/version"

Gem::Specification.new do |gem|
  gem.name    = "sinatra-schema"
  gem.version = Sinatra::Schema::VERSION

  gem.authors     = ["Pedro Belo"]
  gem.email       = ["pedrobelo@gmail.com"]
  gem.homepage    = "https://github.com/pedro/sinatra-schema"
  gem.summary     = "Sinatra extension to support schemas"
  gem.description = "Define a schema to validate requests and responses, expose it as JSON Schema"
  gem.license     = "MIT"

  gem.executables = %x{ git ls-files }.split("\n").select { |d| d =~ /^bin\// }.map { |d| d.gsub(/^bin\//, "") }
  gem.files = %x{ git ls-files }.split("\n").select { |d| d =~ %r{^(License|README|bin/|data/|ext/|lib/|spec/|test/)} }

  gem.add_dependency "activesupport", "~> 4.0", ">= 4.0"
  gem.add_dependency "multi_json",    "~> 1.9", ">= 1.9.3"
  gem.add_dependency "sinatra",       "~> 1.4", ">= 1.4.4"

  gem.add_development_dependency "rack-test", "~> 0.6", ">= 0.6.2"
  gem.add_development_dependency "rspec",     "~> 3.1", ">= 3.1.0"
end
