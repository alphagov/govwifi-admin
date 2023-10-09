require "notifications/client"

module Gateways
  class EmailGateway
    def send_email(opts)
      client = Notifications::Client.new(ENV.fetch("NOTIFY_API_KEY"))
      client.send_email(
        email_address: opts[:email],
        template_id: opts[:template_id],
        personalisation: opts[:locals],
        reference: opts[:reference],
      )
    end
  end

  class EmailGatewayStub
    def send_email(opts)
      puts "Stub email to: #{opts[:email]}"
      puts "...Notifiy TemplateId: #{opts[:template_id]}"
      puts "...Personalisation: #{opts[:locals]}"
      puts "...Reference: #{opts[:reference]}"
    end
  end
end
