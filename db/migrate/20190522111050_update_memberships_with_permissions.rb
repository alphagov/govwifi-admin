class UpdateMembershipsWithPermissions < ActiveRecord::Migration[5.2]
  def up
    add_column :memberships, :can_manage_team, :boolean, default: false, null: false
    add_column :memberships, :can_manage_locations, :boolean, default: false, null: false
  end

  def down
    remove_column :memberships, :can_manage_team
    remove_column :memberships, :can_manage_locations
  end
end
