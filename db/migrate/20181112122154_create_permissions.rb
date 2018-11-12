class CreatePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions do |t|
      t.boolean :can_manage_team
      t.boolean :can_manage_locations
      t.belongs_to :user

      t.timestamps
    end
  end
end
