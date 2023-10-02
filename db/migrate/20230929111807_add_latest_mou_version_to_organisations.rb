class AddLatestMouVersionToOrganisations < ActiveRecord::Migration[7.0]
  def change
    add_column :organisations, :latest_mou_version, :decimal, scale: 1
  end
end
