class RemoveMouTemplates < ActiveRecord::Migration[7.0]
  def up
    drop_table :mou_templates
  end

  def down
    create_table "mou_templates", charset: "utf8", force: :cascade do |t|
      t.datetime "created_at", precision: nil, null: false
      t.datetime "updated_at", precision: nil, null: false
    end
  end
end
