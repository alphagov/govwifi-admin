class MembershipsController < ApplicationController
  before_action :set_membership, only: %i[edit update]
  before_action :validate_can_manage_team, only: %i[edit update]

  def edit;
  end

  def update
    @membership.update(membership_params)
    flash[:notice] = 'Permissions updated'
    redirect_to updated_permissions_team_members_path
  end

private

  def set_membership
    @membership = current_organisation.memberships.find(params.fetch(:id))
  end

  def validate_can_manage_team
    unless current_user.can_manage_team?(current_organisation)
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def membership_params
    params.require(:membership).permit(%i[can_manage_team can_manage_locations])
  end
end
