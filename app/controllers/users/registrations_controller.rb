class Users::RegistrationsController < Devise::RegistrationsController

  def create
    if email_matches_whitelist
      super
    else
      build_resource
      resource.errors.add(
        :email,
        :invalid,
        message: 'only government/whitelisted emails can sign up'
      )
      render 'new'
    end
  end

  protected

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    users_confirmations_pending_path
  end

  def email_matches_whitelist
    email = params.dig(:user, :email)
    email.include?('.gov.uk') || email.include?('@gov.uk')
  end
end
