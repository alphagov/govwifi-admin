class AddConstraintToIpAddresses < ActiveRecord::Migration[5.2]
  def change
    add_index :ips, :address, unique: true
  end
end
