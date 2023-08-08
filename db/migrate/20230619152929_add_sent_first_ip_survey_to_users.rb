class AddSentFirstIpSurveyToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :sent_first_ip_survey, :boolean, default: false, null: false
  end
end
