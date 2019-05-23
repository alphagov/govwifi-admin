class EnableDefaultPermissions < ActiveRecord::Migration[5.2]
  def change
    change_column :memberships, :can_manage_locations, :boolean, default: true, null: false
    change_column :memberships, :can_manage_team, :boolean, default: true, null: false
  end
end
