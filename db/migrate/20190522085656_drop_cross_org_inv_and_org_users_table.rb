class DropCrossOrgInvAndOrgUsersTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :cross_organisation_invitations
    drop_table :organisations_users
  end
end
