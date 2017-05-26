# This middleware modifies the `REQUEST_METHOD` if needed and should be inserted
# after the middleware `Rack::MethodOverride`
#
# All requests coming from Facebook to our canvas are POST requests.
# We need to check whether the request was originally a GET request.
# We assume that Rails inserts a hidden parameter called `utf8` for all non
# GET requests.
#
# So if this parameter is missing, the request is a `GET` request and therefor
# we force the `REQUEST_METHOD` to GET.
#
# Addionally you can restrict `REQUEST_METHOD` rewriting by providing a `custom_filter` block.
module FacebookCanvas
  class Middleware
    ENV_INSIDE = "facebook_canvas.inside".freeze

    def initialize(app, request_host, custom_filter, inside_filter: nil)
      @app = app
      @request_host = proc_for_request_host(request_host)
      @custom_filter = custom_filter
      @inside_filter = inside_filter
    end

    # Forces REQUEST_METHOD to GET if required.
    def call(env)
      inside = match_inside?(env)

      if inside
        self.class.inside!(env)
      end

      if inside && matches_server_name?(env) && was_get_request?(env) && !was_xhr_request?(env) && custom_filter?(env)
        env["REQUEST_METHOD"] = "GET"
      end
      @app.call env
    end

    # Check whether current request is marked as "inside Facebook Canvas"
    def self.inside!(env)
      env[ENV_INSIDE] = true
    end

    # Mark current request as "inside Facebook Canvas"
    def self.inside?(env)
      env[ENV_INSIDE]
    end

    private

    def match_inside?(env)
      @inside_filter.nil? || @inside_filter.call(env)
    end

    def proc_for_request_host(request_host)
      case request_host
      when Regexp
        proc { |env| request_host =~ env["SERVER_NAME"] }
      when Proc
        request_host
      else
        raise ArgumentError, "Expected Regexp or Proc for `request_host` but got: #{request_host.inspect}"
      end
    end

    def matches_server_name?(env)
      @request_host.call(env)
    end

    def was_get_request?(env)
      form_hash = env["rack.request.form_hash"] || {}
      !form_hash["utf8"]
    end

    def was_xhr_request?(env)
      env['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest'
    end

    def custom_filter?(env)
      @custom_filter.call(env)
    end
  end
end
