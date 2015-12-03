# This middleware modifies the `REQUEST_METHOD` if needed and should be inserted
# after the middleware `Rack::MethodOverride`
#
# All requests coming from Facebook to our canvas are POST requests.
# We need to check whether the request was originally a GET request.
# We assume that Rails inserts a hidden parameter called `utf8` for all non
# GET requests.
# So if this parameter is missing, the request is a `GET` request and therefor
# we force the `REQUEST_METHOD` to GET.
module FacebookCanvas
  class Middleware
    def initialize(app, request_host)
      @app = app
      @request_host = request_host
    end

    # Forces REQUEST_METHOD to GET if required.
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
