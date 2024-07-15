class GovWifiMailer < ::Devise::Mailer
  helper :application
  include Rails.application.routes.url_helpers
  include Devise::Controllers::UrlHelpers

  def confirmation_instructions(record, token, _opts = {})
    opts = {
      email: record.email,
      personalisation: { confirmation_url: confirmation_url(record, confirmation_token: token) },
      template_id: NotifyTemplates.template(:confirmation_email),
      reference: "confirmation_email",
    }
    Services.notify_gateway.send_email(opts)
  end

  # Overrides https://github.com/plataformatec/devise/blob/master/app/mailers/devise/mailer.rb#L12
  def reset_password_instructions(record, token, _opts = {})
    opts = {
      email: record.email,
      personalisation: { reset_url: edit_password_url(record, reset_password_token: token) },
      template_id: NotifyTemplates.template(:reset_password_email),
      reference: "reset_password_email",
    }
    Services.notify_gateway.send_email(opts)
  end

  def unlock_instructions(record, token, _opts = {})
    opts = {
      email: record.email,
      personalisation: { unlock_url: unlock_url(record, unlock_token: token) },
      template_id: NotifyTemplates.template(:unlock_account),
      reference: "unlock_account",
    }
    Services.notify_gateway.send_email(opts)
  end

  def invitation_instructions(record, token, _opts = {})
    opts = {
      email: record.email,
      personalisation: { invite_url: accept_invitation_url(record, invitation_token: token) },
      template_id: NotifyTemplates.template(:invite_email),
      reference: "invite_email",
    }
    Services.notify_gateway.send_email(opts)
  end

  def membership_instructions(record, token, opts = {})
    opts = {
      email: record.email,
      personalisation: { invite_url: confirm_new_membership_url(token:),
                         organisation: opts.fetch(:organisation).name },
      template_id: NotifyTemplates.template(:cross_organisation_invitation),
      reference: "invite_email",
    }
    Services.notify_gateway.send_email(opts)
  end

  def nomination_instructions(name, email, nominated_by, organisation, token)
    opts = {
      email:,
      personalisation: { nomination_url: new_nominated_mou_path(token:), name:, nominated_by:, organisation: },
      template_id: NotifyTemplates.template(:nominate_user_to_sign_mou),
      reference: "nomination_email",
    }
    Services.notify_gateway.send_email(opts)
  end

  def thank_you_for_signing_the_mou(name, email_address, organisation_name, mou_signed_date)
    opts = {
      email: email_address,
      personalisation: { name:, organisation: organisation_name, mou_signed_date: },
      template_id: NotifyTemplates.template(:thank_you_for_signing_the_mou),
      reference: "thank_you_email",
    }
    Services.notify_gateway.send_email(opts)
  end

  def notify_user_account_removed(contact)
    opts = {
      email: contact,
      personalisation: {},
      template_id: NotifyTemplates.template("notify_user_account_removed"),
      reference: "notify_user_account_removed",
    }
    Services.notify_gateway.send_email(opts)
  end

  def notify_user_account_removed_sms(contact)
    opts = {
      email: contact,
      personalisation: {},
      template_id: NotifyTemplates.template("notify_user_account_removed_sms"),
      reference: "notify_user_account_removed",
    }
    Services.notify_gateway.send_sms(opts)
  end

  def send_survey(email_address)
    opts = {
      email: email_address,
      personalisation: {},
      template_id: NotifyTemplates.template(:first_ip_survey),
      reference: "first_ip_survey",
    }
    Services.notify_gateway.send_email(opts)
  end
end
