class AddConfirmedAtToCrossOrganisationInvitations < ActiveRecord::Migration[5.2]
  def change
    add_column :cross_organisation_invitations, :confirmed_at, :datetime
  end
end
