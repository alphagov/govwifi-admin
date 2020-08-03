class AddUniquenessIndexToAuthorisedEmailDomain < ActiveRecord::Migration[6.0]
  def change
    add_index :authorised_email_domains, :name, unique: true
  end
end
