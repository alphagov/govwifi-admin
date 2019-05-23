class MembershipsController < ApplicationController
  before_action :set_user, only: %i[edit update]
  before_action :validate_can_manage_team, only: %i[edit update]

  def edit
    @membership = @user.memberships.find(params.fetch(:id))
  end

  def update
    @user.membership_for(current_organisation).update_attributes(membership_params)

    flash[:notice] = 'Permissions updated'
    redirect_to updated_permissions_team_members_path
  end

private

  def set_user
    @user = User.find(params.fetch(:team_member_id))
  end

  def validate_can_manage_team
    unless @user.organisations.include?(current_organisation) && current_user.can_manage_team?(current_organisation)
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def membership_params
    params.require(:membership).permit(%i[can_manage_team can_manage_locations])
  end
end
