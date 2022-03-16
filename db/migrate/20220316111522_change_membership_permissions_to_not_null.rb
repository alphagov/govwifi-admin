class ChangeMembershipPermissionsToNotNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :memberships, :can_manage_team, false, false
    change_column_null :memberships, :can_manage_locations, false, false
  end
end
