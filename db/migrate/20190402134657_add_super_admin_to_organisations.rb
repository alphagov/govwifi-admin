class AddSuperAdminToOrganisations < ActiveRecord::Migration[5.2]
  def change
    add_column :organisations, :super_admin, :boolean, default: false
  end
end
