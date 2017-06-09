source 'https://rubygems.org'

gemspec

rails_version = ENV['RAILS_VERSION']
case rails_version
when /^(\d+\.\d+)/
  gem 'rails', "~> #{$1}.0"
else
  gem 'rails'
end

group :test do
  gem "simplecov"
  gem "codeclimate-test-reporter", "~> 1.0.0"
end
