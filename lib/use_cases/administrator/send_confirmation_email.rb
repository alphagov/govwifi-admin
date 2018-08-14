class SendConfirmationEmail
  TEMPLATE_ID = '5f42e490-ce5e-44e7-9104-805136961116'
  REFERENCE = 'confirmation_email'

  def initialize(notifications_gateway:)
    @notifications_gateway = notifications_gateway
  end

  def execute(email:, confirmation_url:)
    opts = {
      email: email,
      locals: { confirmation_url: confirmation_url },
      template_id: TEMPLATE_ID,
      reference: REFERENCE, 
      email_reply_to_id: nil
    }

    notifications_gateway.send(opts)
  end

  private

  attr_reader :notifications_gateway
end