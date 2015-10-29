require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)
require "facebook_canvas"

module Dummy
  class Application < Rails::Application
  end
end

