$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "facebook_canvas/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "facebook_canvas"
  s.version     = FacebookCanvas::VERSION
  s.authors     = ["André Stuhrmann"]
  s.email       = ["as@neopoly.de"]
  s.summary     = "Summary of FacebookCanvas."
  s.description = "Description of FacebookCanvas."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.1"
end
