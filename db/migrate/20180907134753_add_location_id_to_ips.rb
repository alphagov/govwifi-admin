class AddLocationIdToIps < ActiveRecord::Migration[5.2]
  def change
    remove_reference :ips, :organisation
    add_reference :ips, :location
  end
end
