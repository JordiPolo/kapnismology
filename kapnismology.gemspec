$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "kapnismology/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "kapnismology"
  s.version     = Kapnismology::VERSION
  s.authors     = ['Jordi Polo Carres']
  s.email       = ["mumismo@gmail.com"]
  s.homepage    = "https://www.github.com/JordiPolo/kapnismology"
  s.summary     = "Engine for smoke tests."
  s.description = "Engine for smoke tests and base classes"
  s.license     = "MIT"

  s.files = Dir["{app,config,lib}/**/*", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0"
  s.add_development_dependency 'rspec', '~> 3.2'
  s.add_development_dependency 'byebug', '~> 6.0'
  s.add_development_dependency 'mutant', '~> 0.8'
  s.add_development_dependency 'mutant-rspec', '~> 0.8'

end
