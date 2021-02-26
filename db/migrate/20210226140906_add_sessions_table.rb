class AddSessionsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions, bulk: true do |t|
      t.string :session_id, null: false
      t.text :data
      t.timestamps

      t.index :session_id, unique: true
      t.index :updated_at
    end
  end
end
