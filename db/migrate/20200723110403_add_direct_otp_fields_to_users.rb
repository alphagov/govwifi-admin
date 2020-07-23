class AddDirectOtpFieldsToUsers < ActiveRecord::Migration[6.0]
  change_table :users, bulk: true do |t|
    t.string :direct_otp
    t.datetime :direct_otp_sent_at
  end
end
