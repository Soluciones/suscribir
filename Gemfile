source 'http://rubygems.org'

ruby '2.1.2'

# Declare your gem's dependencies in suscribir.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem 'jquery-rails'
gem 'psique', git: 'https://github.com/Soluciones/Psique.git'
# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
group :develoment, :test do
  gem 'pg'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'capybara'
  gem 'launchy'
  gem 'rspec-rails', '~> 3.0'
  gem 'pry'
  gem 'binding_of_caller'
end

group :test do
  gem 'email_spec'
  gem 'temping'
end
