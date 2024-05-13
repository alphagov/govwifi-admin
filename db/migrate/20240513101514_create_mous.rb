class CreateMous < ActiveRecord::Migration[7.0]
  def change
    create_table :mous do |t|
      t.references :organisation, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.decimal :version, :decimal, precision: 6, scale: 3
      t.string :job_role
      t.string :name
      t.string :email_address
      t.timestamps
    end
  end
end
