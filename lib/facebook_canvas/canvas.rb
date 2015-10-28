# This Middleware should be inserted after Rack::MethodOverride
#
# config/application.rb
#
#     module Panades
#       class Application < Rails::Application
#         ...
#         config.middleware.use "FacebookCanvas"
#         ...
#       end
#     end
#
module FacebookCanvas
  class Canvas
    def initialize(app, request_host)
      @app = app
      @request_host = request_host
    end

    # All requests coming from facebook to our canvas are POST requests.
    # We need to check wether the request was originally a GET request.
    # We assume that rails inserts a hidden parameter with UTF8 for all non
    # GET requests.
    # So if this parameter is missing, the request is a GET request and there for
    # we set the REQUEST_METHOD to GET.
    def call(env)
      if matches_server_name?(env) && was_get_request?(env)
        env["REQUEST_METHOD"] = "GET"
      end
      @app.call env
    end

    private

    def matches_server_name?(env)
      @request_host =~ env["SERVER_NAME"]
    end

    def was_get_request?(env)
      form_hash = env["rack.request.form_hash"] || {}
      !form_hash["utf8"]
    end
  end
end
