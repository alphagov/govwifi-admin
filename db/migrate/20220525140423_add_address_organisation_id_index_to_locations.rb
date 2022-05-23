class AddAddressOrganisationIdIndexToLocations < ActiveRecord::Migration[6.1]
  def change
    add_index :locations, %i[address organisation_id], unique: true
  end
end
