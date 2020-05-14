require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "active_storage/engine" unless ENV["ASSET_PRECOMPILATION_ONLY"]
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GovwifiAdmin
  class Application < Rails::Application
    config.exceptions_app = self.routes

    config.load_defaults 6.0

    # our lib/ folder doesn't follow the Zeitwerk conventions for
    # autoloading, so rely the classic loader instead.
    config.autoloader = :classic

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    # Force HTTPS for all requests except healthcheck endpoint
    config.force_ssl = true
    config.ssl_options = {
      redirect: {
        exclude: ->(request) { request.path =~ /healthcheck/ },
      },
    }

    # https://github.com/alphagov/govuk-frontend/issues/1350
    config.assets.css_compressor = nil

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil
    config.eager_load_paths << Rails.root.join("lib")
  end
end
