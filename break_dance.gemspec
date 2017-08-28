$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "break_dance/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "break_dance"
  s.version     = BreakDance::VERSION
  s.authors     = ["Zlatko Zahariev"]
  s.email       = ["zlatko.zahariev@gmail.com"]
  s.homepage    = "https://github.com/notentered/breakdance"
  s.summary     = "Rails authorization for data-centric applications based on ActiveRecord."
  s.description = "Rails authorization gem."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.0.0"
  s.add_dependency "request_store_rails"

  s.add_development_dependency "sqlite3"
end