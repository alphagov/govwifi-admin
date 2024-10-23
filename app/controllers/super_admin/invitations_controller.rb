class SuperAdmin::InvitationsController <  SuperAdminController
  before_action :delete_user_record, if: :user_should_be_cleared?, only: :create
  after_action :confirm_new_user_membership, only: :update # rubocop:disable Rails/LexicallyScopedActionFilter

  def new
    @permission_level_data = permission_levels
    @user_invitation_form = UserInvitationForm.new
  end

  def create
    organisation = Organisation.find(invite_params[:organisation_id])

    @user_invitation_form = UserInvitationForm.new(invite_params.merge(organisation))

    if @user_invitation_form.valid?
      @user_invitation_form.save!(current_inviter: current_user)
      redirect_to(super_admin_organisation_path(organisation), notice: "#{@user_invitation_form.email} has been invited to join #{organisation.name}")
    else
      @permission_level_data = permission_levels
      render :new
    end
  end

  def update

  end

  def invite_params
    params.require(:user_invitation_form).permit(:email, :permission_level, :organisation_id)
  end

  def permission_levels
    [
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
