class RemoveOrganisationsUsers < ActiveRecord::Migration[5.2]
  def change
    drop_table :organisations_users
  end
end
