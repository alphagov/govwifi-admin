class CreateMous < ActiveRecord::Migration[5.2]
  def change
    create_table :mous do |t|

      t.timestamps
    end
  end
end
