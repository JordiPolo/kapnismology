$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'kapnismology/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'kapnismology'
  s.version     = Kapnismology::VERSION
  s.authors     = ['Jordi Polo Carres']
  s.email       = ['mumismo@gmail.com']
  s.homepage    = 'https://github.com/JordiPolo/kapnismology'
  s.summary     = 'Engine for smoke tests.'
  s.description = 'Engine for smoke tests and base classes'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.7.0'

  s.files = Dir['{app,config,lib}/**/*', 'Rakefile', 'README.md']

  s.add_development_dependency 'actionpack', '>= 5.2'
  s.add_development_dependency 'appraisal', '~> 2.1'
  s.add_development_dependency 'byebug', '~> 10'
  s.add_development_dependency 'capybara', '~> 3.5'
  s.add_development_dependency 'combustion', '~> 1.0'
  s.add_development_dependency 'mutant', '~> 0.8'
  s.add_development_dependency 'mutant-rspec', '~> 0.8'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'rspec-json_expectations', '~> 2.2'
  s.add_development_dependency 'rubocop', '~> 1.42'
  s.add_development_dependency 'rubocop-mdsol', '~> 0.1'
  s.add_development_dependency 'rubocop-performance', '~> 1.15'
  s.add_development_dependency 'simplecov', '~> 0.16'
  s.add_development_dependency 'sqlite3', '~> 1.4'
  s.add_development_dependency 'timecop', '~> 0.7'
end
