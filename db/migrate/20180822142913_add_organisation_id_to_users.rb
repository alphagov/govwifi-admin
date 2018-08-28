class AddOrganisationIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :organisation, index: true
  end
end
