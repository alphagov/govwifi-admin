class CreateNomination < ActiveRecord::Migration[7.0]
  def change
    create_table :nominations do |t|
      t.string :nominated_user_name
      t.string :nominated_user_email
      t.string :nomination_token
      t.belongs_to :organisation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
