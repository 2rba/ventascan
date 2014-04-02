$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ventascan/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ventascan"
  s.version     = Ventascan::VERSION
  s.authors     = ["Serg Tyatin"]
  s.email       = ["700@2rba.com"]
  s.homepage    = "http://2rba.com"
  s.summary     = "unpublished"
  s.description = "unpublished"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency 'RocketAMF'
  s.add_dependency 'rest-client'

  #s.add_development_dependency "sqlite3"
end
