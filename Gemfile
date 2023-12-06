ruby File.read(".ruby-version").strip

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "aws-sdk-route53", "~> 1.78.0"
gem "aws-sdk-s3", "~> 1.132.1"
gem "cancancan"
gem "devise", "~> 4.9.2"
gem "devise_invitable", "~> 2.0.8"
gem "devise_zxcvbn", "~> 6.0.0"
gem "elasticsearch", "~> 8.11.0"
gem "google-apis-drive_v3"
gem "govuk_design_system_formbuilder"
gem "httparty", "~> 0.21.0"
gem "mysql2", "~> 0.5.4"
gem "net-imap", require: false
gem "net-pop", require: false
gem "net-smtp", require: false
gem "notifications-ruby-client", "~> 5.4.0"
gem "pagy", "~> 6.0.4"
gem "puma", "~> 6.3"
gem "rails", "~> 7.0.7"
gem "rqrcode"
gem "sassc-rails"
gem "sentry-rails"
gem "sentry-ruby"
gem "sprockets"
gem "two_factor_authentication"
gem "tzinfo-data"
gem "uk_postcode", "~> 2.1"
gem "zendesk_api"

group :test do
  gem "capybara"
  gem "erb_lint", require: false
  gem "factory_bot_rails"
  gem "faker"
  gem "nokogiri"
  gem "rack_session_access"
  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "rubocop-govuk"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "simplecov-console", require: false
  gem "timecop"
  gem "webmock"
end

group :development do
  gem "web-console"
end

group :development, :test do
  gem "bullet"
  gem "byebug"
  gem "debug", require: false
  gem "listen"
  gem "pry"
  gem "rack-mini-profiler", require: false
  gem "solargraph"
end
