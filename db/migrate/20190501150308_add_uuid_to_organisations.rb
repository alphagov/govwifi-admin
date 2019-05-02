class AddUuidToOrganisations < ActiveRecord::Migration[5.2]
  def change
    add_column :organisations, :uuid, :string, limit: 36, null: false
  end
end
