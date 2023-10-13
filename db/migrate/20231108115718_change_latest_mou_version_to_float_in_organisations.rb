class ChangeLatestMouVersionToFloatInOrganisations < ActiveRecord::Migration[7.0]
  def change
    # rubocop:disable Rails/ReversibleMigration
    change_column :organisations, :latest_mou_version, :float
    # rubocop:enable Rails/ReversibleMigration
  end
end
