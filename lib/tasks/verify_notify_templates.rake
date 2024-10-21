require_relative "../../lib/notify_templates"
desc "Verify if the required templates are present in Notify. Use the notify key as an argument"

task verify_notify_templates: :environment do
  NotifyTemplates.verify_templates
rescue StandardError => e
  abort e.message
end
