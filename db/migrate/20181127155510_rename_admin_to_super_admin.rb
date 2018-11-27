class RenameAdminToSuperAdmin < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :admin, :super_admin
  end
end
