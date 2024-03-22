class CreateCertificatesTable < ActiveRecord::Migration[6.1]
  def change
    create_table :certificates do |t|
      t.string :name
      t.string :issuer
      t.string :subject
      t.date :valid_from
      t.date :valid_to
      t.string :serial_number, unique: true
      t.text :content
      t.bigint :organisation_id

      t.index :serial_number, unique: true
      t.index %i[name organisation_id], unique: true
      t.timestamps
    end
  end
end
