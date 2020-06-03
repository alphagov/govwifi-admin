class Users::TwoFactorAuthentication::SetupController < ApplicationController
  # Skips 2FA so User can set up the totp via QR code
  skip_before_action :handle_two_factor_authentication
  # Skips 2FA setup confirmation callback in ApplicationController.
  skip_before_action :confirm_two_factor_setup

  def show
    if params[:method] == "email"
      render_email_setup
    elsif params[:method] == "app"
      render_app_setup
    else
      render :show
    end
  end

  def update
    if params[:method] == "email"
      save_two_factor_method "email"
      send_email
      redirect_to "/users/two_factor_authentication/email"
      return
    end

    @otp_secret_key = params[:otp_secret_key]
    if current_user.authenticate_totp(params[:code], otp_secret_key: @otp_secret_key)
      current_user.otp_secret_key = @otp_secret_key
      current_user.save(validate: false)
      save_two_factor_method "app"
      flash[:notice] = "Two factor authentication setup successful"
      disable_2fa_checks_for_session
    else
      flash[:alert] = "Six digit code is not valid"
      # TODO: Replace with route helper once fully migrate to new 2FA routes.
      redirect_back(fallback_location: "/users/two_factor_authentication/setup")
    end
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
  helper_method :qr_code_uri

private

  def save_two_factor_method(method)
    # TODO: This will be implemented in future.
  end

  def send_email
    # TODO: This will be implemented in future.
  end

  def render_app_setup
    # Used to populate the QR code used in setup.
    @otp_secret_key = ROTP::Base32.random_base32
    render :show_app
  end

  def render_email_setup
    render :show_email
  end

  def disable_2fa_checks_for_session
    # Ensures the user doesn't go through 2FA check again.
    request.env["warden"].session(:user)[TwoFactorAuthentication::NEED_AUTHENTICATION] = false
    redirect_to stored_location_for(:user) || root_path
  end

  def sidebar
    :empty
  end
end
