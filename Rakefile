require 'rspec/core/rake_task'
require './lib/sinatra/schema/version'

RSpec::Core::RakeTask.new(:spec)
task default: :spec

desc "Cut a new version specified in VERSION and push"
task :release do
  unless ENV["VERSION"]
    abort("ERROR: Missing VERSION. Currently at #{Sinatra::Schema::VERSION}")
  end

  current_version = Gem::Version.new(Sinatra::Schema::VERSION)
  new_version = Gem::Version.new(ENV["VERSION"])

  if current_version >= new_version
    abort("ERROR: Invalid version, already at #{Sinatra::Schema::VERSION}")
  end

  # update lib/sinatra/schema/version.rb
  sh "ruby",
    "-i",
    "-pe",
    "$_.gsub!(/VERSION = .*/, %{VERSION = \"#{new_version}\"})",
    "lib/sinatra/schema/version.rb"

  # tag/commit
  sh "bundle install"
  sh "git commit -a -m 'v#{new_version}'"
  sh "git tag v#{new_version}"

  # build new gem and push
  sh "gem build sinatra-schema.gemspec"
  sh "gem push sinatra-schema-#{new_version}.gem"
  sh "git push origin master --tags"
  sh "rm sinatra-schema-#{new_version}.gem"
end
