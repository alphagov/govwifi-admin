class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!, except: :error
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_action :redirect_user_with_no_organisation, unless: :current_action_is_valid?

  helper_method :current_organisation, :super_admin?

  def current_organisation
    @current_organisation ||= begin
      if current_user.organisations.pluck(:id).include?(session[:organisation_id].to_i)
        Organisation.find(session[:organisation_id])
      else
        current_user.organisations.first
      end
    end
  end

  def error
    render :error, code: params[:code]
  end

  def super_admin?
    current_organisation&.super_admin?
  end

protected

  def authorise_manage_locations
    redirect_to(root_path) unless current_user.can_manage_locations?(current_organisation)
  end

  def configure_devise_permitted_parameters
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:name])
  end

  def redirect_user_with_no_organisation
    if current_user&.organisations&.empty?
      msg = "You do not belong to an organisation. Please mention this in your support request."
      redirect_to signed_in_new_help_path, notice: msg
    end
  end

  def current_action_is_valid?
    controller_name == 'help' && valid_help_actions.include?(action_name)
  end

  def valid_help_actions
    @valid_help_actions ||= %w(signed_in create).freeze
  end
end
