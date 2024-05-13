class CreateCertificatesTable < ActiveRecord::Migration[6.1]
  def change
    create_table :certificates do |t|
      t.string :fingerprint, unique: true
      t.string :name
      t.string :issuer
      t.string :subject
      t.datetime :not_before
      t.datetime :not_after
      t.string :serial
      t.text :content
      t.bigint :organisation_id

      t.index %i[fingerprint organisation_id], unique: true
      t.index %i[name organisation_id], unique: true
      t.timestamps
    end
  end
end
