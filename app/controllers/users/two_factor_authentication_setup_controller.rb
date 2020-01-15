class Users::TwoFactorAuthenticationSetupController < ApplicationController
  # Skips 2FA so User can set up the totp via QR code
  skip_before_action :handle_two_factor_authentication
  # Skips 2FA setup confirmation callback in ApplicationController.
  skip_before_action :confirm_two_factor_setup
  before_action :validate_can_manage_team, only: %i[edit destroy]

  def edit
    @user = User.find(params.fetch(:id))
  end

  def show
    # Used to populate the QR code used in setup.
    @otp_secret_key = ROTP::Base32.random_base32
  end

  def update
    if params[:commit] == 'Remind me next time'
      # Ensures the user doesn't go through 2FA check again.
      request.env['warden'].session(:user)[TwoFactorAuthentication::NEED_AUTHENTICATION] = false
      flash[:notice] = "Two factor authentication setup skipped until next time"
      redirect_to stored_location_for(:user) || root_path
      return
    end

    @otp_secret_key = params[:otp_secret_key]
    if current_user.authenticate_totp(params[:code], otp_secret_key: @otp_secret_key)
      current_user.otp_secret_key = @otp_secret_key
      current_user.save(validate: false)

      # Ensures the user doesn't go through 2FA check again.
      request.env["warden"].session(:user)[TwoFactorAuthentication::NEED_AUTHENTICATION] = false

      flash[:notice] = "Two factor authentication setup successful"
      redirect_to stored_location_for(:user) || root_path
    else
      flash[:alert] = "Six digit code is not valid"
      render "show"
    end
  end

  def destroy
    @user = User.find(params.fetch(:id))

    @user.reset_2fa!

    redirect_path = if current_organisation&.super_admin?
                      super_admin_organisations_path
                    else
                      memberships_path
                    end

    redirect_to redirect_path, notice: "Two factor authentication has been reset"
  end

  def validate_can_manage_team
    user = User.find(params.fetch(:id))

    redirect_to root_path unless current_user.can_manage_other_user_for_org?(user, current_organisation)
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
end
