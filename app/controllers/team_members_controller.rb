class TeamMembersController < ApplicationController
  before_action :set_user, only: %i[edit update]
  before_action :validate_can_manage_team, only: %i[edit update]
  helper_method :sort_column, :sort_direction

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

  def sorted_team_members(organisation)
    UseCases::Administrator::SortUsers.new(
      users_gateway: Gateways::OrganisationUsers.new(organisation: organisation)
    ).execute
  end

  def set_user
    @user = User.find(params.fetch(:id))
  end

  def validate_can_manage_team
    unless users_belong_to_same_org && current_user.can_manage_team?(current_organisation)
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def users_belong_to_same_org
    @user.organisations.include?(current_organisation)
  end

  def membership_params
    params.require(:user).permit(memberships_attributes: %i[can_manage_team can_manage_locations id])
  end
end
