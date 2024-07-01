require_relative "../../lib/deploy"
if Deploy.production?
  Sentry.init do |config|
    config.dsn = ENV["SENTRY_DSN"]
    config.breadcrumbs_logger = %i[sentry_logger http_logger]
  end
end
