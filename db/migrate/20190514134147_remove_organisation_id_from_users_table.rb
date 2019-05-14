class RemoveOrganisationIdFromUsersTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :organisation_id
  end
end
