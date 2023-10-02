namespace :mou do
  desc "Update latest MOU version"
  task update_latest_version: :environment do
    Organisation.find_each do |organisation|
      new_version = 4 # Set the version here
      organisation.update!(latest_mou_version: new_version, mou_version_date: Time.zone.today)
    end

    puts "Latest MOU versions updated"
  end
end
