ruby File.read(".ruby-version").strip

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'aws-sdk-route53', '~> 1.0.0.rc13'
gem 'devise', '~> 4.5.0'
gem 'devise_invitable', '~> 1.7.0'
gem 'mysql2', '~> 0.5.2'
gem 'notifications-ruby-client', '~> 2.7.0'
gem 'puma', '~> 3.12'
gem 'rails', '~> 5.2.1'
gem 'sass-rails', '~> 5.0'

group :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'database_cleaner'
  gem 'factory_bot_rails', '~> 4.11'
  gem 'govuk-lint', '~> 3'
  gem 'nokogiri'
  gem 'rspec-rails', '~> 3'
  gem 'shoulda-matchers', '~> 3.1'
end

group :development, :test do
  gem 'byebug', '~> 10'
  gem 'listen', '~> 3'
  gem 'pry'
end
