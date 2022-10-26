ruby File.read(".ruby-version").strip

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "aws-sdk-route53", "~> 1.65.0"
gem "aws-sdk-s3", "~> 1.117.0"
gem "cancancan"
gem "devise", "~> 4.8.1"
gem "devise_invitable", "~> 2.0.6"
gem "devise_zxcvbn", "~> 6.0.0"
gem "google-apis-drive_v3"
gem "govuk_design_system_formbuilder"
gem "httparty", "~> 0.20.0"
gem "mysql2", "~> 0.5.4"
gem "net-imap", require: false
gem "net-pop", require: false
gem "net-smtp", require: false
gem "notifications-ruby-client", "~> 5.3.0"
gem "pagy", "~> 5.10.1"
gem "puma", "~> 5.6"
gem "rails", "~> 7.0.4"
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
  gem "factory_bot_rails", "~> 6.2.0"
  gem "faker"
  gem "guard-rspec"
  gem "nokogiri"
  gem "rack_session_access"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 6.0.0"
  gem "rubocop-govuk", "~> 4"
  gem "shoulda-matchers", "~> 5.2"
  gem "simplecov", require: false
  gem "simplecov-console", require: false
  gem "timecop", "~> 0.9.5"
  gem "webmock", "~> 3.18.1"
end

group :development do
  gem "web-console"
end

group :development, :test do
  gem "bullet", "~> 7.0"
  gem "byebug", "~> 11"
  gem "listen", "~> 3"
  gem "pry"
  gem "rack-mini-profiler", require: false
end
