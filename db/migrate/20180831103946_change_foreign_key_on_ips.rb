class ChangeForeignKeyOnIps < ActiveRecord::Migration[5.2]
  def change
    remove_reference :ips, :user, index: true
    add_reference :ips, :organisation, index: true
  end
end
