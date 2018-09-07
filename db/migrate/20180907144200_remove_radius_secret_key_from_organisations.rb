class RemoveRadiusSecretKeyFromOrganisations < ActiveRecord::Migration[5.2]
  def change
    remove_column :organisations, :radius_secret_key, :string
  end
end
