class Users::InvitationsController < Devise::InvitationsController
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
    render_invite_user_page if user_is_invalid?
  end

  def user_is_invalid?
    @user = User.new(invite_params)
    !@user.validate
  end

  def render_invite_user_page
    render :new, resource: @user
  end

  def invited_user_already_exists?
    !!User.find_by(email: invite_params[:email])
  end

  # Overrides https://github.com/scambra/devise_invitable/blob/master/app/controllers/devise/invitations_controller.rb#L105
  def invite_params
    params.require(:user).permit(:email, :organisation_id)
  end
end
