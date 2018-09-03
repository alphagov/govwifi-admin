if %w[production staging].include?(ENV['RACK_ENV'])
  Raven.configure do |config|
    config.dsn = ENV['SENTRY_DSN']
  end
end
