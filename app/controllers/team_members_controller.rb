class TeamMembersController < ApplicationController
  before_action :set_user, only: %i[edit update]
  before_action :validate_can_manage_team, only: %i[edit update]
  helper_method :sort_column, :sort_direction

  def index
    unsorted_team_members = current_user&.organisation&.users || []
    @team_members = unsorted_team_members.order("#{sort_column} #{sort_direction}")
  end

  def destroy
    user = current_organisation.users.find_by(id: params.fetch(:id))
    redirect_to team_members_path && return unless user

    user.destroy
    redirect_to team_members_path, notice: "Team member has been removed"
  end

  def edit; end

  def update
    @user.permission.update!(permission_params[:permission_attributes])

    flash[:notice] = 'Permissions updated'
    redirect_to team_members_path
  end

private

  def set_user
    @user = User.find(params.fetch(:id))
  end

  def validate_can_manage_team
    unless users_belong_to_same_org && current_user.can_manage_team?
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def users_belong_to_same_org
    current_user.organisation == @user.organisation
  end

  def permission_params
    params.require(:user).permit(permission_attributes: %i[can_manage_team can_manage_locations])
  end

  def sortable_columns
    %w[name]
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
