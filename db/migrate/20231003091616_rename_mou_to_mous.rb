class RenameMouToMous < ActiveRecord::Migration[7.0]
  def change
    rename_table :mou, :mous
  end
end
