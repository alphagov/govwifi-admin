class CreateMembershipsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :memberships do |t|

      t.timestamps
    end
  end
end
