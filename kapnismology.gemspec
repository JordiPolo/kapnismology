$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'kapnismology/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'kapnismology'
  s.version     = Kapnismology::VERSION
  s.authors     = ['Jordi Polo Carres']
  s.email       = ['mumismo@gmail.com']
  s.homepage    = 'https://www.github.com/JordiPolo/kapnismology'
  s.summary     = 'Engine for smoke tests.'
  s.description = 'Engine for smoke tests and base classes'
  s.license     = 'MIT'

  s.files = Dir['{app,config,lib}/**/*', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_development_dependency 'rails', '>= 3.2.13'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'rspec-json_expectations', '~> 1.4'
  s.add_development_dependency 'byebug', '~> 9.0'
  s.add_development_dependency 'mutant', '~> 0.8'
  s.add_development_dependency 'mutant-rspec', '~> 0.8'
  s.add_development_dependency 'appraisal', '~> 2.1'
  s.add_development_dependency 'combustion', '~> 0.5.3'
  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'timecop', '~> 0.7'
end
