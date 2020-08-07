class Users::TwoFactorAuthentication::SetupController < ApplicationController
  # Skips 2FA so User can set up the totp via QR code
  skip_before_action :handle_two_factor_authentication
  # Skips 2FA setup confirmation callback in ApplicationController.
  skip_before_action :confirm_two_factor_setup
  skip_before_action :choose_two_factor_method
  skip_before_action :redirect_user_with_no_organisation

  def show; end

  def update
    if params[:method] == "email"
      redirect_to "/users/two_factor_authentication/email/confirmation"
    else
      redirect_to "/users/two_factor_authentication/app/totp_with_qr"
    end
  end

private

  def sidebar
    :empty
  end
end
