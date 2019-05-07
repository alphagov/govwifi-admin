class AddIndexesToUsersOrganisations < ActiveRecord::Migration[5.2]
  def change
    add_index :organisations_users, :organisation_id
    add_index :organisations_users, :user_id
    add_index :organisations_users, %i(organisation_id user_id), unique: true
  end
end
