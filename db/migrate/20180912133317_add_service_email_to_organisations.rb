class AddServiceEmailToOrganisations < ActiveRecord::Migration[5.2]
  def change
    add_column :organisations, :service_email, :string
  end
end
