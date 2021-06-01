ruby File.read(".ruby-version").strip

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "aws-sdk-route53", "~> 1.44.0"
gem "aws-sdk-s3", "~> 1.94.1"
gem "cancancan"
gem "devise", "~> 4.7.3"
gem "devise_invitable", "~> 2.0.3"
gem "devise_zxcvbn", "~> 5.1.0"
gem "httparty", "~> 0.18.1"
gem "jquery-rails"
gem "mysql2", "~> 0.5.2"
gem "notifications-ruby-client", "~> 5.3.0"
gem "puma", "~> 5.3"
gem "rails", "~> 6.1"
gem "rqrcode"
gem "sassc-rails"
gem "sentry-raven"
gem "sprockets", "3.7.2"
gem "two_factor_authentication"
gem "tzinfo-data"
gem "uk_postcode", "~> 2.1"
gem "zendesk_api"

group :test do
  gem "capybara"
  gem "erb_lint", require: false
  gem "factory_bot_rails", "~> 6.2"
  gem "faker"
  gem "guard-rspec"
  gem "nokogiri"
  gem "rack_session_access"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 4"
  gem "rubocop-govuk"
  gem "shoulda-matchers", "~> 4.4"
  gem "simplecov", require: false
  gem "simplecov-console", require: false
  gem "timecop", "~> 0.9.2"
  gem "webmock", "~> 3.10.0"
end

group :development, :test do
  gem "bullet", "~> 6.0"
  gem "byebug", "~> 11"
  gem "listen", "~> 3"
  gem "pry"
  gem "rack-mini-profiler", require: false
  gem "spring-commands-rspec"
end
