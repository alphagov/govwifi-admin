require "notifications/client"

module Gateways
  class EmailGateway
    def self.send_email(opts)
      client = Notifications::Client.new(ENV.fetch("NOTIFY_API_KEY"))
      client.send_email(
        email_address: opts[:email],
        template_id: opts[:template_id],
        personalisation: opts[:locals],
        reference: opts[:reference],
      )
    end
  end
end
