class RemoveSuperAdminFromOrganisation < ActiveRecord::Migration[6.1]
  def change
    remove_column :organisations, :super_admin, :boolean
  end
end
