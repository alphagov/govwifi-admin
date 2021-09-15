class DropPermissionsTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :permissions
  end

  def down
    create_table "permissions", charset: "utf8", force: :cascade do |t|
      t.boolean "can_manage_team"
      t.boolean "can_manage_locations"
      t.bigint "user_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index %w[user_id], name: "index_permissions_on_user_id"
    end
  end
end
