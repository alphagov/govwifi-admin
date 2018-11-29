class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!, except: :error
  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  helper_method :current_organisation

  def current_organisation
    @current_organisation ||= current_user.organisation
  end

  def error
    render :error, code: params[:code]
  end

protected

  def authorise_manage_locations
    redirect_to(root_path) unless current_user.can_manage_locations?
  end

  def configure_devise_permitted_parameters
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:name])
  end
end
