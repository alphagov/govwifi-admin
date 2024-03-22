class DropCertificatesTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :certificates
  end

  def down; end
end
