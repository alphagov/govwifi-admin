module GovWifiAuthenticatable
  extend ActiveSupport::Concern
  included do
    before_action :authenticate_user!, except: :error
    before_action :confirm_two_factor_setup

    before_action :configure_devise_permitted_parameters, if: :devise_controller?
    before_action :redirect_user_with_no_organisation, unless: :current_action_is_valid?
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

  def redirect_user_with_no_organisation
    if !current_user&.is_super_admin? && current_user&.organisations&.empty?
      msg = "You do not belong to an organisation. Please mention this in your support request."
      redirect_to signed_in_new_help_path, notice: msg
    end
  end

  def current_action_is_valid?
    devise_controller? || (controller_name == "help" && valid_help_actions.include?(action_name))
  end
end
