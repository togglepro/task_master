$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "task_master/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "task_master"
  s.version     = TaskMaster::VERSION
  s.authors     = ["Sean Devine"]
  s.email       = ["barelyknown@icloud.com"]
  s.homepage    = "http://www.github.com/togglepro/task_master"
  s.summary     = "A Rails engine that makes it easy to outsource manual tasks using the Fancy Hands API."
  s.description = s.summary
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.4"
  s.add_dependency "task_master-fancyhands-ruby"

  s.add_development_dependency "pg"
  s.add_development_dependency "spring", "~> 1.3"
  s.add_development_dependency "rspec-rails", ">= 3.3.3"
  s.add_development_dependency "factory_girl_rails", "~> 4.5"
  s.add_development_dependency "dotenv", "~> 2.0"
  s.add_development_dependency "test_after_commit"
end
