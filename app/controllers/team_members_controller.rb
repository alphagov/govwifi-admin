class TeamMembersController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_user, only: %i[edit update]

  def index
    @team_members = sorted_team_members(current_organisation)
  end

  def destroy
    user = current_organisation.users.find_by(id: params.fetch(:id))
    redirect_to team_members_path && return unless user

    user.destroy
    redirect_to removed_team_members_path, notice: "Team member has been removed"
  end

private

  def set_user
    @user = User.find(params.fetch(:id))
  end

  def sorted_team_members(organisation)
    UseCases::Administrator::SortUsers.new(
      users_gateway: Gateways::OrganisationUsers.new(organisation: organisation)
    ).execute
  end
end
