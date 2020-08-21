class Users::TwoFactorAuthentication::Setup::AppController < ApplicationController
  # Skips 2FA so User can set up the totp via QR code
  skip_before_action :handle_two_factor_authentication
  # Skips 2FA setup confirmation callback in ApplicationController.
  skip_before_action :confirm_two_factor_setup
  skip_before_action :choose_two_factor_method
  skip_before_action :redirect_user_with_no_organisation

  helper_method :qr_code_uri

  def show
    @otp_secret_key = otp_secret_key
  end

private

  def otp_secret_key
    params[:otp_secret_key] =~ /^[A-Z0-9]{32}$/ ? params[:otp_secret_key] : ROTP::Base32.random_base32
  end

  def qr_code_uri
    provisioning_uri = current_user.provisioning_uri(
      current_user.email,
      otp_secret_key: @otp_secret_key,
      issuer: "GovWifi (#{ENV['RACK_ENV']})",
        )
    qr_code = RQRCode::QRCode.new(provisioning_uri, level: :m)
    qr_code.as_png(size: 180, fill: ChunkyPNG::Color::TRANSPARENT).to_data_url
  end
end
