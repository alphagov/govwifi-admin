class AddConfirmedAtCol < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :confirmed_at, :datetime
  end
end
