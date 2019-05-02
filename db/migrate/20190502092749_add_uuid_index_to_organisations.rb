class AddUuidIndexToOrganisations < ActiveRecord::Migration[5.2]
  def change
    add_index :organisations, :uuid, unique: true
  end
end
