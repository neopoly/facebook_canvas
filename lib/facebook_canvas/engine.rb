module FacebookCanvas
  class Engine < ::Rails::Engine
    initializer "FacebookCanvas.middleware" do |app|
      app.config.middleware.use FacebookCanvas::Middleware, /\.fb\./

      ApplicationController.prepend FacebookCanvas::Helpers
    end
  end
end
