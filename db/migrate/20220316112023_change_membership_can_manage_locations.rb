class ChangeMembershipCanManageLocations < ActiveRecord::Migration[6.1]
  def up
    execute "UPDATE memberships SET can_manage_locations = 1 WHERE can_manage_team = 1 AND can_manage_locations = 0"
  end

  def down; end
end
