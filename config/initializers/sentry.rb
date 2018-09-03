if %w[production staging].include?(ENV['RACK_ENV'])
  require 'raven'

  Raven.configure do |config|
    config.dsn = ENV['SENTRY_DSN']
  end

  use Raven::Rack
end
