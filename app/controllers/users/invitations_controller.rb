class Users::InvitationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:edit, :update]

  before_action :authorise_inviter!, only: [:new, :create, :resend_invitation, :invite_second_admin]

  def new
    @permission_level_data = permission_levels

    @user_invitation_form = UserInvitationForm.new
  end

  def create
    @user_invitation_form = UserInvitationForm.new(invite_params.merge(organisation: current_organisation))

    if @user_invitation_form.valid?
      @user_invitation_form.save!(current_inviter: current_user)
      redirect_to(memberships_path, notice: "#{@user_invitation_form.email} has been invited to join #{current_organisation.name}")
    else
      @permission_level_data = permission_levels
      render :new
    end
  end

  def edit
    @accept_user_invitation_form = AcceptUserInvitationForm.new(invitation_token: params[:invitation_token])
    redirect_to root_path if @accept_user_invitation_form.invalid_invitation_token?
  end

  def update
    @accept_user_invitation_form = AcceptUserInvitationForm.new(accept_user_invitation_params)
    if @accept_user_invitation_form.invalid?
      render :edit
    else
      @accept_user_invitation_form.save!
      redirect_to root_path
    end
  end

  def invite_second_admin
    @user_invitation_form = UserInvitationForm.new
  end

  def resend_invitation
    invited_user = User.find_by!(email: params[:email])
    token = invited_user.membership_for(current_organisation)&.invitation_token
    raise "Invalid token" if token.nil?

    UserInvitationForm.send_invite(invited_user, token, current_organisation)
  end

private

  def authorise_inviter!
    unless current_user&.can_manage_team?(current_organisation)
      redirect_to(root_path) and return
    end
  end

  def accept_user_invitation_params
    params.require(:accept_user_invitation_form).permit(:invitation_token, :name, :password)
  end

  def token
    params[:token] || params.dig(:permission_level, :token)
  end

  def show_navigation_bars
    false if action_name == "invite_second_action"
  end

  def send_invite_email(membership)
    GovWifiMailer.membership_instructions(
      invited_user,
      membership.invitation_token,
      organisation: membership.organisation,
    ).deliver_now
  end

  def invite_params
    params.require(:user_invitation_form).permit(:email, :permission_level)
  end

  def permission_levels
    @permission_level_data = [
      OpenStruct.new(
        value: "administrator",
        text: "Administrator",
        hint: <<~HINT.html_safe,
          <span>View locations and IPs, team members, and logs</span><br>
          <span>Manage locations and IPs</span><br>
          <span>Add or remove team members</span><br>
          <span>View, add and remove certificates</span>
        HINT
      ),
      OpenStruct.new(
        value: "manage_locations",
        text: "Manage Locations",
        hint: <<~HINT.html_safe,
          <span>View locations and IPs, team members, and logs</span><br>
          <span>Manage locations and IPs</span><br>
          <span>Cannot add or remove team members</span><br>
          <span>View, add and remove certificates</span>
        HINT
      ),
      OpenStruct.new(
        value: "view_only",
        text: "View only",
        hint: <<~HINT.html_safe,
          <span>View locations and IPs, team members, and logs</span><br>
          <span>Cannot manage locations and IPs</span><br>
          <span>Cannot add or remove team members</span>
        HINT
      ),
    ]
  end
end
