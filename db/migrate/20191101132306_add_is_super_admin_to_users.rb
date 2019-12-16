class AddIsSuperAdminToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_super_admin, :boolean, default: false, null: false
    Organisation.super_admins.first.users.update_all(is_super_admin: true)
  end
end
