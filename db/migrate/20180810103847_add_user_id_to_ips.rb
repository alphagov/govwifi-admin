class AddUserIdToIps < ActiveRecord::Migration[5.1]
  def change
    add_reference :ips, :user, index: true
  end
end
