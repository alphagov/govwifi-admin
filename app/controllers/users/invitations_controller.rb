class Users::InvitationsController < Devise::InvitationsController
  before_action :authorise_manage_team, only: %i(create new)
  before_action :add_organisation_to_params, :validate_invited_user, only: :create

private

  def after_invite_path_for(_resource)
    team_members_path
  end

  def add_organisation_to_params
    params[:user][:organisation_id] = current_user.organisation_id
  end

  def validate_invited_user
    return if invited_user_already_exists?
    return_user_to_invite_page unless email_is_valid?
  end

  def email_is_valid?
    return true if email_passes_validation?
    set_user_object_with_errors
    false
  end

  def email_passes_validation?
    invite_params[:email].match(URI::MailTo::EMAIL_REGEXP).present?
  end

  def set_user_object_with_errors
    @user = User.new(invite_params)
    @user.errors.add(:email, " must be a valid email address")
  end

  def return_user_to_invite_page
    render :new, resource: @user
  end

  def invited_user_already_exists?
    !!User.find_by(email: invite_params[:email])
  end

  # Overrides https://github.com/scambra/devise_invitable/blob/master/app/controllers/devise/invitations_controller.rb#L105
  def invite_params
    params.require(:user).permit(:email, :organisation_id, permission_attributes: %i(
      can_manage_team
      can_manage_locations
    ))
  end

  def authorise_manage_team
    redirect_to(root_path) unless current_user.can_manage_team?
  end
end
