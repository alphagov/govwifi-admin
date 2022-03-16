class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pagy::Backend
  include GovWifiAuthenticatable

  before_action :redirect_user_with_no_organisation, unless: :devise_controller?
  helper_method :current_organisation, :super_admin?
  helper_method :sidebar
  helper_method :subnav

  def current_organisation
    if session[:organisation_id] && current_user.organisations.pluck(:id).include?(session[:organisation_id].to_i)
      Organisation.find(session[:organisation_id])
    else
      current_user.organisations.first
    end
  end

  def super_admin?
    current_user&.is_super_admin?
  end

  def redirect_user_with_no_organisation
    if current_user&.organisations&.empty?
      redirection_url, message = if current_user&.is_super_admin?
                                   [super_admin_organisations_path, "You do not belong to an organisation."]
                                 else
                                   [signed_in_new_help_path,
                                    "You do not belong to an organisation. Please mention this in your support request."]
                                 end
      redirect_to redirection_url, notice: message
    end
  end

protected

  def subnav
    :default
  end

  def sidebar
    :default
  end

  def authorise_manage_locations
    redirect_to(root_path) unless current_user.can_manage_locations?(current_organisation)
  end
end
