class CreateNomination < ActiveRecord::Migration[7.0]
  def change
    create_table :nominations do |t|
      t.string :name
      t.string :email
      t.string :token
      t.belongs_to :organisation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
