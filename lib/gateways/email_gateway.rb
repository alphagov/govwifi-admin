require "notifications/client"

module Gateways
  class EmailGateway
    def initialize
      @client = Notifications::Client.new(ENV.fetch("NOTIFY_API_KEY"))
    end

    def send(opts)
      client.send_email(
        email_address: opts[:email],
        template_id: opts[:template_id],
        personalisation: opts[:locals],
        reference: opts[:reference],
      )
    end

  private

    attr_reader :client
  end
end
