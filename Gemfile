source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'
gem 'sass-rails'
gem 'webpacker'
gem 'turbolinks'
gem 'jbuilder'
gem 'active_model_serializers'
gem 'aws-sdk-s3', require: false
gem 'bootsnap', require: false
gem 'bootstrap'
gem 'cancancan'
gem 'cocoon'
gem 'database_cleaner'
gem 'devise'
gem 'doorkeeper'
gem 'gon'
gem 'handlebars-source'
gem 'jquery-rails'
gem 'mini_racer'
gem 'mysql2'
gem 'thinking-sphinx'
gem 'octicons'
gem 'octicons_helper'
gem 'oj'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-vkontakte'
gem 'popper_js'
gem 'redis-rails'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim-rails'
gem 'simple_form'
gem 'unicorn'
gem 'whenever', require: false

group :development, :test do 
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'letter_opener'
  gem 'capybara-email'
end

group :development do 
  gem 'web-console'
  gem 'listen',
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test do 
  gem 'capybara'
  gem 'launchy'
  gem 'selenium-webdriver' 
  gem 'webdrivers'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
