ruby File.read(".ruby-version").strip

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'aws-sdk-route53', '~> 1.27.0'
gem 'aws-sdk-s3', '~> 1'
gem 'cancancan'
gem 'devise', '~> 4.6.2'
gem 'devise_invitable', '~> 2.0.1'
gem 'devise_zxcvbn', '~> 5.1.0'
gem 'httparty', '~> 0.17.0'
gem 'mysql2', '~> 0.5.2'
gem 'notifications-ruby-client', '~> 4.0.0'
gem 'puma', '~> 4.0'
gem 'rails', '~> 5.2.3'
gem 'rqrcode'
gem 'sass-rails', '~> 5.1'
gem 'sentry-raven'
gem 'sprockets', '4.0.0beta10'
gem 'two_factor_authentication'
gem 'tzinfo-data'
gem 'uk_postcode', '~> 2.1'
gem 'zendesk_api'

group :test do
  gem 'capybara'
  gem 'erb_lint', require: false
  gem 'factory_bot_rails', '~> 5.0'
  gem 'faker'
  gem 'govuk-lint', '~> 3'
  gem 'guard-rspec'
  gem 'nokogiri'
  gem 'rack_session_access'
  gem 'rspec-rails', '~> 3'
  gem 'shoulda-matchers', '~> 4.1'
  gem 'simplecov', require: false
  gem 'simplecov-console', require: false
  gem 'timecop', '~> 0.9.1'
  gem 'webmock', '~> 3.6.0'
end

group :development, :test do
  gem 'bullet', '~> 6.0'
  gem 'byebug', '~> 11'
  gem 'listen', '~> 3'
  gem 'pry'
  gem 'rack-mini-profiler', require: false
  gem 'spring-commands-rspec'
end
