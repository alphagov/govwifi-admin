class AllowNullMembershipsPermissions < ActiveRecord::Migration[5.2]
  def change
    change_column :memberships, :can_manage_team, :boolean, null: true, default: 1
    change_column :memberships, :can_manage_locations, :boolean, null: true, default: 1
  end
end
