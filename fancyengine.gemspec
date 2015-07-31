$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fancyengine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fancyengine"
  s.version     = Fancyengine::VERSION
  s.authors     = ["Sean Devine"]
  s.email       = ["barelyknown@icloud.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Fancyengine."
  s.description = "TODO: Description of Fancyengine."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.3"

  s.add_development_dependency "pg"

  s.add_development_dependency "rspec-rails", "~> 3.3"
  s.add_development_dependency "factory_girl_rails", "~> 4.5"
  s.add_development_dependency "dotenv", "~> 2.0"
end
