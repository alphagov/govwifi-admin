class TeamMembersController < ApplicationController
  def index
    @team_members = current_user&.organisation&.users || []
  end

  def destroy
    if org.id != current_user.organisation_id
    user = User.find(params[:id])
    user.destroy
    redirect_to team_members_path, notice: "Team member has been successfully removed"
  end
end
