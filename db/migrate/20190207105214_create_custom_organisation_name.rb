class CreateCustomOrganisationName < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_organisation_names do |t|
      t.string :name

      t.timestamps
    end
  end
end
