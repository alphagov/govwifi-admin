namespace :mou do
  desc "Update latest MOU version"
  task :update_latest_version, [:new_version] => :environment do |_, args|
    new_version = args[:new_version].to_f # manually update version number using the command 'rake mou:update_latest_version[4]'

    Organisation.find_each do |organisation|
      organisation.update!(latest_mou_version: new_version, mou_version_change_date: Time.zone.today)
    end

    puts "Latest MOU versions updated to version #{new_version}"
  end
end
