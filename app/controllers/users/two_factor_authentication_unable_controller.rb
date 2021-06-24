class Users::TwoFactorAuthenticationUnableController < ApplicationController
  before_action :redirect_if_super_admin
  skip_before_action :handle_two_factor_authentication
  skip_before_action :confirm_two_factor_setup, :redirect_user_with_no_organisation

  def show; end

  def update
    disable_2fa_checks_for_session
    redirect_to stored_location_for(:user) || root_path
  end

private

  def disable_2fa_checks_for_session
    request.env["warden"].session(:user)[TwoFactorAuthentication::NEED_AUTHENTICATION] = false
  end

  def redirect_if_super_admin
    redirect_to root_path if super_admin?
  end
end
