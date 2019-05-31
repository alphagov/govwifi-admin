class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!, except: :error
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_action :ensure_user_belongs_to_organisation, unless: :current_action_is_valid?

  helper_method :current_organisation, :super_admin?

  def current_organisation
    if session[:organisation_id] && current_user.organisations.pluck(:id).include?(session[:organisation_id].to_i)
      Organisation.find(session[:organisation_id])
    else
      current_user.organisations.first
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

  def ensure_user_belongs_to_organisation
    if current_user && current_user.organisations.empty?
      message = 'Please select your organisation'

      redirect_to new_organisation_path, notice: message
    end
  end

  def current_action_is_valid?
    valid_actions_for_orphaned_user.fetch(controller_name, []).include?(action_name)
  end

  def valid_actions_for_orphaned_user
    @valid_actions_for_orphaned_user ||= {
      'current_organisation' => %w(edit),
      'organisations' => %w(new create),
      'help' => %w(new create technical_support user_support admin_account)
    }.freeze
  end
end
