class Users::TwoFactorAuthentication::SetupController < ApplicationController
  # Skips 2FA so User can set up the totp via QR code
  skip_before_action :handle_two_factor_authentication
  # Skips 2FA setup confirmation callback in ApplicationController.
  skip_before_action :confirm_two_factor_setup

  def show

  end

  private

  def sidebar
    :empty
  end
end
