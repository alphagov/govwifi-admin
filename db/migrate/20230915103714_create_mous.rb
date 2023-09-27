class CreateMous < ActiveRecord::Migration[7.0]
  def change
    create_table :mous do |t|
      t.references :organisation, null: false, foreign_key: true
      t.string :organisation_name
      t.date :signed_date
      t.string :user_name
      t.string :user_email
      t.string :version
      t.boolean :signed

      t.timestamps
    end
  end
end
