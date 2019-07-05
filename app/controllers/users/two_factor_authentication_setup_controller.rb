class Users::TwoFactorAuthenticationSetupController < ApplicationController
  # Skips 2FA so User can set up the totp via QR code
  skip_before_action :handle_two_factor_authentication
  # Redirect to 2FA action if totp set up is complete
  before_action :redirect_to_two_factor_authentication, if: -> { current_user.reload.totp_enabled? }

  def show
    # Used to populate the QR code used in setup.
    @otp_secret_key = ROTP::Base32.random_base32
  end

  def update
    otp_secret_key = params[:otp_secret_key]
    if current_user.authenticate_totp(params[:code], otp_secret_key: otp_secret_key)
      current_user.otp_secret_key = otp_secret_key
      current_user.save(validate: false)

      redirect_to stored_location_for(:user)
    else
      flash[:alert] = 'MFA code does not match QR code.'
      render 'show'
    end
  end

  def qr_code_uri
    provisioning_uri = current_user.provisioning_uri(
      current_user.email, otp_secret_key: @otp_secret_key
    )
    qr_code = RQRCode::QRCode.new(provisioning_uri, level: :m)
    qr_code.as_png(size: 180, fill: ChunkyPNG::Color::TRANSPARENT).to_data_url
  end
  helper_method :qr_code_uri

private

  def redirect_to_two_factor_authentication
    redirect_to user_two_factor_authentication_path
  end
end
