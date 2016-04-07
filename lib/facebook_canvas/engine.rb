module FacebookCanvas
  class Engine < ::Rails::Engine
    DEFAULT_SERVER_REGEX = /.*/
    DEFAULT_CUSTOM_FILTER = proc { |_env| true }

    initializer "FacebookCanvas.middleware" do |app|
      server_name = FacebookCanvas.server_name || DEFAULT_SERVER_REGEX
      custom_filter = FacebookCanvas.custom_filter || DEFAULT_CUSTOM_FILTER
      app.config.middleware.use FacebookCanvas::Middleware, server_name, custom_filter

      ApplicationController.prepend FacebookCanvas::Helpers
    end
  end
end
