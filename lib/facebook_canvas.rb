require "facebook_canvas/engine" if defined? Rails
require "facebook_canvas/middleware"
require "facebook_canvas/helpers"
require "facebook_canvas/signed_request"

module FacebookCanvas
  mattr_accessor :server_name
end