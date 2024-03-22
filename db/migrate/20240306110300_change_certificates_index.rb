class ChangeCertificatesIndex < ActiveRecord::Migration[6.1]
  def change
    remove_index :certificates, :thumbprint, unique: true # rubocop:disable Rails/BulkChangeTable
    add_index :certificates, %i[organisation_id thumbprint], unique: true
  end
end
