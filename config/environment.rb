# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

GovwifiAdmin::Application.default_url_options = GovwifiAdmin::Application.config.action_mailer.default_url_options
