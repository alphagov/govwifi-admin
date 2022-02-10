ruby File.read(".ruby-version").strip

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "aws-sdk-route53", "~> 1.61.0"
gem "aws-sdk-s3", "~> 1.112.0"
gem "cancancan"
gem "devise", "~> 4.8.1"
gem "devise_invitable", "~> 2.0.6"
gem "devise_zxcvbn", "~> 6.0.0"
gem "google-apis-drive_v3"
gem "govuk_design_system_formbuilder"
gem "httparty", "~> 0.20.0"
gem "mysql2", "~> 0.5.2"
gem "notifications-ruby-client", "~> 5.3.0"
gem "pagy", "~> 5.8.1"
gem "puma", "~> 5.6"
gem "rails", "~> 6.1.4"
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
  gem "rspec-rails", "~> 5.1.0"
  gem "rubocop-govuk", "~> 4"
  gem "shoulda-matchers", "~> 5.1"
  gem "simplecov", require: false
  gem "simplecov-console", require: false
  gem "timecop", "~> 0.9.2"
  gem "webmock", "~> 3.14.0"
end

group :development, :test do
  gem "bullet", "~> 7.0"
  gem "byebug", "~> 11"
  gem "listen", "~> 3"
  gem "pry"
  gem "rack-mini-profiler", require: false
  gem "spring-commands-rspec"
end
