source 'https://rubygems.org'


gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'font-awesome-rails'
gem 'kaminari'

gem 'compass-rails'
# https://github.com/Compass/compass/pull/2088
git 'https://github.com/ably-forks/compass', branch: 'sass-deprecation-warning-fix' do
  gem 'compass-core'
end

# https://github.com/plataformatec/devise
gem 'devise'

# https://github.com/elabs/pundit
gem 'pundit'

# https://github.com/RolifyCommunity/rolify
gem 'rolify'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'

# State Machine
gem 'aasm'

# time difference
gem 'time_difference'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Use RSpec for testing
  gem 'rspec-rails', '~> 3.5'
  
  # Added for assert_template helper
  gem 'rails-controller-testing'
  
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  
  # Use factory girl to generate test resources
  gem 'factory_girl_rails'

  # Use Faker to generate test resources
  gem 'faker'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]