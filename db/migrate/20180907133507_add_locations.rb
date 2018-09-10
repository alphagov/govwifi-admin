class AddLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :radius_secret_key
      t.string :address
      t.string :postcode
      t.references :organisation

      t.timestamps
    end
  end
end
