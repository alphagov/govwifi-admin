class Users::RegistrationsController < Devise::RegistrationsController
  alias :rebuild_devise_user :build_resource

  def create
    if email_matches_whitelist
      do_default_devise_behaviour
    else
      rebuild_devise_user
      add_error_to_devise_user
      render 'new'
    end
  end

protected

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(_resource)
    users_confirmations_pending_path
  end

  def do_default_devise_behaviour
    Devise::RegistrationsController
      .instance_method(:create).bind(self).call
  end

  def email_matches_whitelist
    email = params.dig(:user, :email)
    return false if email.blank?

    domain = email.split('@').last
    domain.starts_with?('gov.uk') || domain.include?('.gov.uk')
  end

  def add_error_to_devise_user
    resource.errors.add(
      :email,
      :invalid,
      message: 'only government/whitelisted emails can sign up'
    )
  end
end
