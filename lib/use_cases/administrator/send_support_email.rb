class SendSupportEmail
  REFERENCE = 'support_email'.freeze

  def initialize(notifications_gateway:)
    @notifications_gateway = notifications_gateway
  end

  def execute(email:, template_id:, subject:, name:, sender_email:, phone:, organisation:, details:)
    opts = {
      email: email,
      locals: { name: name, sender_email: sender_email, phone: phone, organisation: organisation, details: details, subject: subject },
      template_id: template_id,
      reference: REFERENCE,
      email_reply_to_id: nil
    }

    notifications_gateway.send(opts)
  end

private

  attr_reader :notifications_gateway
end
