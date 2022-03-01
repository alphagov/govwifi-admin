class AuthenticationMailer < ::Devise::Mailer
  helper :application
  include Rails.application.routes.url_helpers
  include Devise::Controllers::UrlHelpers

  def confirmation_instructions(record, token, _opts = {})
    confirmation_link = confirmation_url(record, confirmation_token: token)
    template_id = GOV_NOTIFY_CONFIG["confirmation_email"]["template_id"]

    UseCases::Administrator::SendConfirmationEmail.new(
      notifications_gateway: Gateways::EmailGateway.new,
    ).execute(
      email: record.email,
      confirmation_url: confirmation_link,
      template_id:,
    )
  end

  # Overrides https://github.com/plataformatec/devise/blob/master/app/mailers/devise/mailer.rb#L12
  def reset_password_instructions(record, token, _opts = {})
    reset_link = edit_password_url(record, reset_password_token: token)
    template_id = GOV_NOTIFY_CONFIG["reset_password_email"]["template_id"]

    UseCases::Administrator::SendResetPasswordEmail.new(
      notifications_gateway: Gateways::EmailGateway.new,
    ).execute(
      email: record.email,
      reset_url: reset_link,
      template_id:,
    )
  end

  def unlock_instructions(record, token, _opts = {})
    unlock_link = unlock_url(record, unlock_token: token)
    template_id = GOV_NOTIFY_CONFIG["unlock_account"]["template_id"]

    UseCases::Administrator::SendUnlockEmail.new(
      notifications_gateway: Gateways::EmailGateway.new,
    ).execute(
      email: record.email,
      unlock_url: unlock_link,
      template_id:,
    )
  end

  def invitation_instructions(record, token, _opts = {})
    invite_link = accept_invitation_url(record, invitation_token: token)
    template_id = GOV_NOTIFY_CONFIG["invite_email"]["template_id"]

    UseCases::Administrator::SendInviteEmail.new(
      notifications_gateway: Gateways::EmailGateway.new,
    ).execute(
      email: record.email,
      invite_url: invite_link,
      template_id:,
    )
  end

  def membership_instructions(record, token, opts = {})
    invite_link = confirm_new_membership_url(token:)
    template_id = GOV_NOTIFY_CONFIG["cross_organisation_invitation"]["template_id"]

    UseCases::Administrator::SendMembershipInviteEmail.new(
      notifications_gateway: Gateways::EmailGateway.new,
    ).execute(
      email: record.email,
      invite_url: invite_link,
      template_id:,
      organisation: opts.fetch(:organisation),
    )
  end
end
