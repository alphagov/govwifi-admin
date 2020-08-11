class Users::TwoFactorAuthenticationController < Devise::TwoFactorAuthenticationController
  helper_method :tfa_feature_flag?, :method

  skip_before_action :choose_two_factor_method, only: :update
  before_action :validate_can_manage_team, only: %i[edit destroy]
  before_action :handle_missing_2fa_method, only: :update
  skip_before_action :redirect_user_with_no_organisation

  def update
    super
  end

  def show
    @resent = !!params[:resent]
  end

  def handle_missing_2fa_method
    return if current_user.second_factor_method.present?

    redirect_to :root_path && return if params[:method].nil?
    if params[:method] == "email"
      current_user.update(second_factor_method: "email")
      current_user.send_new_otp
    elsif current_user.authenticate_totp(params[:code], otp_secret_key: params[:otp_secret_key])
      current_user.update(second_factor_method: "app", otp_secret_key: params[:otp_secret_key])
    else
      set_flash_message :alert, :attempt_failed
      redirect_to "/users/two_factor_authentication/setup/app", params: params
    end
  end

  def edit
    @user = User.find(params.fetch(:id))
  end

  def destroy
    @user = User.find(params.fetch(:id))

    @user.reset_2fa!

    redirect_path = if current_user.super_admin?
                      super_admin_organisations_path
                    else
                      memberships_path
                    end

    redirect_to redirect_path, notice: "Two factor authentication has been reset"
  end

  def method
    tfa_feature_flag? ? current_user&.second_factor_method : "app"
  end

  def validate_can_manage_team
    user = User.find(params.fetch(:id))

    redirect_to root_path unless current_user.can_manage_other_user_for_org?(user, current_organisation)
  end
end
