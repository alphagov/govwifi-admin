class AddMouVersionChangeDateToOrganisations < ActiveRecord::Migration[7.0]
  def change
    add_column :organisations, :mou_version_change_date, :date
  end
end
