source 'https://rubygems.org'

ruby '2.5.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'

gem 'aliyun-sdk', github: 'mycolorway/aliyun-oss-ruby-sdk'
gem 'connection_pool', '~> 2.2.1'
gem 'dalli', '~> 2.7.8'
gem 'dotenv-rails', '~> 2.2.1'
gem 'fast_blank', '~> 1.0.0'
gem 'kgio', '~> 2.11.2'
gem 'pry-rails', '~> 0.3.6'
# Use Puma as the app server
gem 'puma', '~> 3.7'
gem 'puma_worker_killer', '~> 0.1.0'
# gem 'redis-rails', '~> 5.0.2'
gem 'remote_lock', github: 'mycolorway/remote_lock' # '~> 1.1.0'
gem 'rest-client', '~> 2.0.2'
gem 'sentry-raven', '~> 2.6.3'
gem 'wannabe_bool', '~> 0.6.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
