class AuthenticationMailer < ::Devise::Mailer
  helper :application
  include Rails.application.routes.url_helpers
  include Devise::Controllers::UrlHelpers

  def confirmation_instructions(record, token, _opts = {})
    confirmation_link = confirmation_url(record, confirmation_token: token)

    SendConfirmationEmail.new(
      notifications_gateway: EmailGateway.new
    ).execute(email: record.email, confirmation_url: confirmation_link)
  end
end
