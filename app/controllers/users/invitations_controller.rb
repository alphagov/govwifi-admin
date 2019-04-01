class Users::InvitationsController < Devise::InvitationsController
  before_action :set_target_organisation, if: :super_admin?, only: %i(create new)
  before_action :delete_user_record, if: :user_should_be_cleared?, only: :create
  before_action :return_user_to_invite_page, if: :user_is_invalid?, only: :create
  before_action :add_organisation_to_params, unless: :super_admin?, only: :create

  helper_method :super_admin?

private

  def authenticate_inviter!
    # https://github.com/scambra/devise_invitable#controller-filter
    redirect_to(root_path) unless current_user&.can_manage_team?
  end

  def add_organisation_to_params
    params[:user][:organisation_id] = current_user.organisation_id
  end

  def delete_user_record
    invited_user.destroy!
  end

  def return_user_to_invite_page
    respond_with_navigational(resource) { render :new }
  end

  def set_target_organisation
    @target_organisation = Organisation.find_by(id: params[:id] || invite_params[:organisation_id])
  end

  def user_is_invalid?
    # This is an indirect solution to preventing a user being re-invited when they belong
    # to another organisation.
    self.resource = resource_class.new(invite_params)
    resource.invalid?
  end

  def invited_user
    @invited_user ||= User.find_by(email: invite_params[:email])
  end

  def resending_invite?
    !!params[:resend]
  end

  def after_invite_path_for(_resource)
    if super_admin?
      admin_organisation_path(invite_params[:organisation_id])
    else
      resending_invite? ? recreated_invite_team_members_path : created_invite_team_members_path
    end
  end

  def user_should_be_cleared?
    resending_invite? || unconfirmed_user_with_no_org?
  end

  def unconfirmed_user_with_no_org?
    invited_user_already_exists? && invited_user_not_confirmed? && invited_user_has_no_org?
  end

  def invited_user_already_exists?
    !!invited_user
  end

  def invited_user_not_confirmed?
    !invited_user.confirmed?
  end

  def invited_user_has_no_org?
    invited_user.organisation_id.nil?
  end

  def super_admin?
    current_user.super_admin?
  end

  # Overrides https://github.com/scambra/devise_invitable/blob/master/app/controllers/devise/invitations_controller.rb#L105
  def invite_params
    params.require(:user).permit(:email, :organisation_id, permission_attributes: %i(
      can_manage_team
      can_manage_locations
    ))
  end
end
