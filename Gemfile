ruby File.read(".ruby-version").strip

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "aws-sdk-route53", "~> 1.31.0"
gem "aws-sdk-s3", "~> 1"
gem "cancancan"
gem "devise", "~> 4.7.1"
gem "devise_invitable", "~> 2.0.1"
gem "devise_zxcvbn", "~> 5.1.0"
gem "httparty", "~> 0.18.0"
gem "mysql2", "~> 0.5.2"
gem "notifications-ruby-client", "~> 5.1.2"
gem "puma", "~> 4.3"
gem "rails", "~> 5.2.3"
gem "rqrcode"
gem "sass-rails", "~> 5.1"
gem "sentry-raven"
gem "two_factor_authentication"
gem "tzinfo-data"
gem "uk_postcode", "~> 2.1"
gem "zendesk_api"

group :test do
  gem "capybara"
  gem "erb_lint", require: false
  gem "factory_bot_rails", "~> 5.0"
  gem "faker"
  gem "guard-rspec"
  gem "nokogiri"
  gem "rack_session_access"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 3"
  gem "rubocop-govuk"
  gem "scss_lint-govuk"
  gem "shoulda-matchers", "~> 4.3"
  gem "simplecov", require: false
  gem "simplecov-console", require: false
  gem "timecop", "~> 0.9.1"
  gem "webmock", "~> 3.8.2"
end

group :development, :test do
  gem "bullet", "~> 6.0"
  gem "byebug", "~> 11"
  gem "listen", "~> 3"
  gem "pry"
  gem "rack-mini-profiler", require: false
  gem "spring-commands-rspec"
end
