class ApplicationController < ActionController::Base
  include Pagy::Backend
  include GovWifiAuthenticatable

  protect_from_forgery with: :exception

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
    current_user&.super_admin?
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

  def valid_help_actions
    @valid_help_actions ||= %w[signed_in create].freeze
  end
end
