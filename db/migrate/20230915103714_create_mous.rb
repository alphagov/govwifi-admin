class CreateMous < ActiveRecord::Migration[7.0]
  def change
    create_table :mous do |t|
      t.references :organisation, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :signed_date
      t.decimal :version
      t.boolean :signed

      t.timestamps
    end
  end
end
