class ChangeVersionToFloatInMous < ActiveRecord::Migration[7.0]
  def change
    # rubocop:disable Rails/ReversibleMigration
    change_column :mous, :version, :float
    # rubocop:enable Rails/ReversibleMigration
  end
end
