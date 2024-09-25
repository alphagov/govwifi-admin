desc "Verify if the required templates are present in Notify. Use the notify key as an argument"

task verify_notify_templates: :environment do
  NotifyTemplates.verify_templates
  puts "OK"
rescue StandardError => e
  puts e.message
  abort e.message
end
