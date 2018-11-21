class TeamMembersController < ApplicationController
  def index
    @team_members = current_user&.organisation&.users || []
  end

  def destroy
    user = current_organisation.users.find_by(id: params.fetch(:id))
    redirect_to team_members_path && return unless user

    user.destroy
    redirect_to team_members_path, notice: "Team member has been removed"
  end
end
