module GovWifiAuthenticatable
  extend ActiveSupport::Concern
  included do
    before_action :authenticate_user!, except: :error
    before_action :confirm_two_factor_setup
    before_action :configure_devise_permitted_parameters, if: :devise_controller?
  end

  def error
    render :error, code: params[:code]
  end

  def confirm_two_factor_setup
    return unless current_user &&
      current_user.need_two_factor_authentication?(request) &&
      !current_user.totp_enabled?

    redirect_to users_two_factor_authentication_setup_path
  end

  def configure_devise_permitted_parameters
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:name])
  end
end
