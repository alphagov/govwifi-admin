require "notifications/client"

module Gateways
  class SmsGateway
    def send_sms(opts)
      client = Notifications::Client.new(ENV.fetch("NOTIFY_API_KEY"))
      client.send_sms(
        phone_number: opts[:contact],
        template_id: opts[:template_id],
        personalisation: opts[:locals],
      )
    end
  end

  class SmsGatewayStub
    def send_sms(opts)
      puts "Stub sms to: #{opts[:contact]}"
      puts "...Notifiy TemplateId: #{opts[:template_id]}"
      puts "...Personalisation: #{opts[:locals]}"
    end
  end
end
