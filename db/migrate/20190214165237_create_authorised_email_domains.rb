class CreateAuthorisedEmailDomains < ActiveRecord::Migration[5.2]
  def change
    create_table :authorised_email_domains do |t|
      t.string :name

      t.timestamps
    end
  end
end
