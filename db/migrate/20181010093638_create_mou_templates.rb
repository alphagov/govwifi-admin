class CreateMouTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :mou_templates do |t|

      t.timestamps
    end
  end
end
