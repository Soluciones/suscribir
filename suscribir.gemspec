$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'suscribir/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'suscribir'
  s.version     = Suscribir::VERSION
  s.authors     = ['Rankia']
  s.email       = ['rails@rankia.com']
  s.homepage    = 'https://github.com/Soluciones/suscribir'
  s.summary     = 'An engine to handle subscriptions'
  s.description = s.summary

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 4.2.0'
  s.add_dependency 'draper'
  s.add_dependency 'haml-rails'
end
