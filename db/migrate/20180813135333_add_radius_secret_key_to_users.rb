class AddRadiusSecretKeyToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :radius_secret_key, :string
  end
end
