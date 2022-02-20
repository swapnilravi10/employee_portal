source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
# Use sqlite3 as the database for Active Record
gem 'pg', '~> 1.2.3'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '= 5.1.0'
gem 'sassc', '= 2.1.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Country select
gem 'country_select', '~> 4.0'
# simple calendar
gem "simple_calendar", "~> 2.4"
# Sidekiq
gem 'sidekiq', '~>6.0.0'
# Cron for sidekiq
gem 'sidekiq-cron'
# wicked_gem
gem 'wicked_pdf'
# wkhtmltopdf
gem 'wkhtmltopdf-binary'
# kaminari for pagination
gem 'kaminari'
# browser detection -> https://github.com/fnando/browser
gem "browser"
# hashid-rails
gem 'hashid-rails', '~> 1.4'
# aws sdk
gem 'aws-sdk'


gem 'mini_racer', platforms: :ruby
# Figaro for dynamic environments
gem 'figaro', '~> 1.2'
#carrierwave --> to upload multiple images
gem 'carrierwave', '~> 2.0'

#fog-aws for carrierwave to upload to AWS
gem "fog-aws"

gem 'rabl-rails'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
gem "bootstrap", "~> 4.5"    
gem "jquery-rails", "~> 4.3"
gem 'croppie_rails'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'  
  gem 'pry'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
