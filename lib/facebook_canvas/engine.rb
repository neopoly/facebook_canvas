module FacebookCanvas
  class Engine < ::Rails::Engine
    initializer "FacebookCanvas.middleware" do |app|
      server_name = FacebookCanvas.server_name || /\.fb\./
      app.config.middleware.use FacebookCanvas::Middleware, server_name

      ApplicationController.prepend FacebookCanvas::Helpers
    end
  end
end
