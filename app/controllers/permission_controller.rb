class PermissionController < ApplicationController
  before_action :validate_can_manage_team, only: %i[edit update]

  def edit
    @permission = Permission.find(params.fetch(:id))
    @show_remove_partial = request.path.include?("remove")
  end

  def update
    Permission.find(params.fetch(:id)).update!(permission_params)

    flash[:notice] = 'Permissions updated'
    redirect_to team_members_path
  end

private

  def validate_can_manage_team
    permission = Permission.find(params.fetch(:id))

    unless current_user.organisation == permission.user.organisation && current_user.can_manage_team?
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def permission_params
    params.require(:permission).permit(:can_manage_team, :can_manage_locations)
  end
end
