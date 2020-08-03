class Users::TwoFactorAuthentication::EmailController < ApplicationController
  # Skips 2FA so User can set up the totp via QR code
  skip_before_action :handle_two_factor_authentication
  # Skips 2FA setup confirmation callback in ApplicationController.
  skip_before_action :confirm_two_factor_setup
  skip_before_action :choose_two_factor_method

  def confirmation; end

  def resend_form; end

  def update
    current_user.send_new_otp
    redirect_to user_two_factor_authentication_path(resent: "true")
  end

private

  def sidebar
    :empty
  end
end
