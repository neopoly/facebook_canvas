module FacebookCanvas
  class Engine < ::Rails::Engine
    initializer "FacebookCanvas.middleware" do |app|
      server_name = FacebookCanvas.server_name || /.*/
      custom_filter = FacebookCanvas.custom_filter || proc { |_env| true }
      app.config.middleware.use FacebookCanvas::Middleware, server_name, custom_filter

      ApplicationController.prepend FacebookCanvas::Helpers
    end
  end
end
