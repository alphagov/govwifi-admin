class CreateCertificates < ActiveRecord::Migration[7.0]
  def create
    create_table :certificates do |t|
      t.string :name
      t.string :issuer
      t.string :subject
      t.date :valid_from
      t.date :valid_to
      t.string :serial_number
      t.text :content
      t.bigint :organisation_id

      t.timestamps
    end
  end
end
