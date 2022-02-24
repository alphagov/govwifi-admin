class MembershipsController < ApplicationController
  before_action :set_membership, only: %i[edit update destroy]
  before_action :validate_can_manage_team, only: %i[edit update destroy]

  def edit; end

  def update
    @membership.update!(membership_params)
    flash[:notice] = "Permissions updated"
    redirect_to updated_permissions_memberships_path
  end

  def index
    @team_members = sorted_team_members(current_organisation)
  end

  def destroy
    @membership.destroy!
    @membership.user.destroy! unless @membership.user.memberships.any?

    redirect_path = if current_organisation&.super_admin?
                      super_admin_organisation_path(@membership.organisation)
                    else
                      removed_memberships_path
                    end

    redirect_to redirect_path, notice: "Team member has been removed"
  end

private

  def set_membership
    scope = current_organisation.super_admin? ? Membership : current_organisation.memberships
    @membership = scope.find(params.fetch(:id))
  end

  def validate_can_manage_team
    unless current_user.can_manage_team?(current_organisation)
      raise ActionController::RoutingError, "Not Found"
    end
  end

  def sorted_team_members(organisation)
    UseCases::Administrator::SortUsers.new(
      users_gateway: Gateways::OrganisationUsers.new(organisation:),
    ).execute
  end

  def membership_params
    params.require(:membership).permit(%i[can_manage_team can_manage_locations])
  end
end
