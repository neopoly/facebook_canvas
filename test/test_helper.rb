require "simplecov"
SimpleCov.start

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../../test/dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

require "minitest/focus" unless ENV["CI"]
require "minitest/spec"

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

ActionDispatch::IntegrationTest.include Support::HttpMethodCompatibility

class ActiveSupport::TestCase
  extend Minitest::Spec::DSL
end
