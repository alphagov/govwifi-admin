require "notifications/client"

module Gateways
  class DevelopmentNotifyGateway
    def initialize(_) end

    def send_email(opts)
      puts "Stub email to: #{opts[:email]}"
      puts "...Notifiy TemplateId: #{opts[:template_id]}"
      puts "...Personalisation: #{opts[:personalisation]}"
      puts "...Reference: #{opts[:reference]}"
    end

    def send_sms(opts)
      puts "Stub sms to: #{opts[:contact]}"
      puts "...Notifiy TemplateId: #{opts[:template_id]}"
      puts "...Personalisation: #{opts[:personalisation]}"
    end
  end
end
