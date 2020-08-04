class AddUniquenessIndexToOrganisation < ActiveRecord::Migration[6.0]
  def change
    add_index :organisations, :name, unique: true
  end
end
