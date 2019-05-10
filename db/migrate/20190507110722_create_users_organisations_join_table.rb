class CreateUsersOrganisationsJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table(:users, :organisations)
  end
end
