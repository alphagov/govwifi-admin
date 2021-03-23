class DropSessionsTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :sessions do |t|
      t.string :session_id, null: false
      t.text :data
      t.timestamps

      t.index :session_id, unique: true
      t.index :updated_at
    end
  end
end
