require 'notifications/client'

class EmailGateway
  def initialize
    @client =  Notifications::Client.new(ENV.fetch('NOTIFICATIONS_API_KEY'))
  end

  def send(opts)
    client.send_email(
      email_address: opts[:email],
      template_id: opts[:template_id],
      personalisation: opts[:locals],
      reference: opts[:reference],
      email_reply_to_id: opts[:email_reply_to_id]
    )
  end

  private

  attr_reader :client
end
