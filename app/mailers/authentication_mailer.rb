class AuthenticationMailer < ::Devise::Mailer
  helper :application
  include Rails.application.routes.url_helpers
  include Devise::Controllers::UrlHelpers

  def confirmation_instructions(record, token, _opts = {})
    confirmation_link = confirmation_url(record, confirmation_token: token)
    template_id = GOV_NOTIFY_CONFIG['confirmation_email']['template_id']

    SendConfirmationEmail.new(
      notifications_gateway: EmailGateway.new
    ).execute(
      email: record.email,
      confirmation_url: confirmation_link,
      template_id: template_id
    )
  end

  # Overrides https://github.com/plataformatec/devise/blob/master/app/mailers/devise/mailer.rb#L12
  def reset_password_instructions(record, token, _opts = {})
    reset_link = edit_password_url(record, reset_password_token: token)
    template_id = GOV_NOTIFY_CONFIG['reset_password_email']['template_id']

    SendResetPasswordEmail.new(
      notifications_gateway: EmailGateway.new
    ).execute(
      email: record.email,
      reset_url: reset_link,
      template_id: template_id
    )
  end

  def invitation_instructions(record, token, _opts={})
    puts "Invitations system is hitting custom mailer class"
    invitation_link = accept_invitation_url(record, invitation_token: token)
    puts invitation_link
  end
end
