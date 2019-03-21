class Users::InvitationsController < Devise::InvitationsController
  before_action :authorise_manage_team, only: %i(create new)
  before_action :delete_user_record, if: :user_should_be_cleared?, only: :create
  before_action :add_organisation_to_params, :validate_invited_user, only: :create

private

  def authorise_manage_team
    redirect_to(root_path) unless current_user.can_manage_team?
  end

  def add_organisation_to_params
    params[:user][:organisation_id] = current_user.organisation_id
  end

  def validate_invited_user
    return_user_to_invite_page if user_is_invalid?
  end

  def delete_user_record
    invited_user.destroy!
  end

  def invited_user
    @invited_user ||= User.find_by(email: invite_params[:email])
    @invited_user = User.find_by(email: invite_params[:email]) if @invited_user&.destroyed?
    @invited_user
  end

  def resending_invite?
    !!params[:resend]
  end

  def after_invite_path_for(_resource)
    team_members_path
  end

  def user_should_be_cleared?
    resending_invite? || unconfirmed_user_with_no_org?
  end

  def unconfirmed_user_with_no_org?
    invited_user_already_exists? && invited_user_not_confirmed? && invited_user_has_no_org?
  end

  def user_is_invalid?
    @user = User.new(invite_params)
    !@user.validate
  end

  def return_user_to_invite_page
    render :new, resource: @user
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

  # Overrides https://github.com/scambra/devise_invitable/blob/master/app/controllers/devise/invitations_controller.rb#L105
  def invite_params
    params.require(:user).permit(:email, :organisation_id, permission_attributes: %i(
      can_manage_team
      can_manage_locations
    ))
  end


end
