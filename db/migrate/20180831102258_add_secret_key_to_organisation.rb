class AddSecretKeyToOrganisation < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :radius_secret_key, :string
    add_column :organisations, :radius_secret_key, :string
  end
end
