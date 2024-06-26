class NotifyTemplates
  TEMPLATES = %w[
    confirmation_email
    reset_password_email
    unlock_account
    invite_email
    cross_organisation_invitation
    nominate_user_to_sign_mou
    thank_you_for_signing_the_mou
    first_ip_survey
  ].freeze

  def self.template_hash
    templates = Services.email_gateway.all_templates
    templates.slice(*TEMPLATES)
  end

  def self.template(name)
    template_hash.fetch(name.is_a?(Symbol) ? name.to_s : name)
  end
end
