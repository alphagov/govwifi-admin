class ChangeVersionDataTypeInMous < ActiveRecord::Migration[7.0]
  def up
    change_column :mous, :version, :decimal, scale: 1
  end

  def down
    change_column :mous, :version, :integer
  end
end
