class Users::TwoFactorAuthentication::EmailController < ApplicationController
  # Skips 2FA so User can set up the totp via QR code
  skip_before_action :handle_two_factor_authentication
  # Skips 2FA setup confirmation callback in ApplicationController.
  skip_before_action :confirm_two_factor_setup
  skip_before_action :choose_two_factor_method

  def show
    if params[:resend] == "true"
      render :show_resend
    else
      @resent = true if params[:resent] == "true"
      render :show
    end
  end

  def update
    if params[:resend] == "true"
      send_email
      redirect_to "/users/two_factor_authentication/email?resent=true"
    end
  end

private

  def send_email
    # TODO: This will be implemented in future.
  end

  def sidebar
    :empty
  end
end
