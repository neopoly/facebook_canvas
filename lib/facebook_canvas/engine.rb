module FacebookCanvas
  class Engine < ::Rails::Engine
   initializer "FacebookCanvas.middleware" do |app|
      app.config.middleware.use "FacebookCanvas::Middleware", /\.fb\./
    end
  end
end
