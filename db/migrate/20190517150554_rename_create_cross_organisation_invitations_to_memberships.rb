class RenameCreateCrossOrganisationInvitationsToMemberships < ActiveRecord::Migration[5.2]
  def change
    rename_table :cross_organisation_invitations, :memberships
  end
end
