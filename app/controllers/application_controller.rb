class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pagy::Backend
  include GovWifiAuthenticatable

  before_action :redirect_user_without_organisation, unless: :current_action_is_valid?
  helper_method :current_organisation, :super_admin?
  helper_method :sidebar
  helper_method :subnav

  def current_organisation
    if session[:organisation_id] && current_user.organisations.pluck(:id).include?(session[:organisation_id].to_i)
      Organisation.find(session[:organisation_id])
    elsif !current_user.is_super_admin?
      current_user.organisations.first
    end
  end

  def super_admin?
    current_user&.is_super_admin?
  end

  def redirect_user_with_no_organisation
    if !current_user&.is_super_admin? && current_user&.organisations&.empty?
      msg = "You do not belong to an organisation. Please mention this in your support request."
      redirect_to signed_in_new_help_path, notice: msg
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

  def current_action_is_valid?
    devise_controller? || (controller_name == "help" && valid_help_actions.include?(action_name))
  end

  def valid_help_actions
    @valid_help_actions ||= %w[signed_in create].freeze
  end
end
