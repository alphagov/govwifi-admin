class ChangeLatestMouVersionToDecimalInOrganisations < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      change_column_null :organisations, :latest_mou_version, true
      change_column_default :organisations, :latest_mou_version, from: nil, to: 0

      dir.up do
        change_column :organisations, :latest_mou_version, :decimal, precision: 3, scale: 1
      end

      dir.down do
        change_column :organisations, :latest_mou_version, :integer
      end
    end
  end
end
