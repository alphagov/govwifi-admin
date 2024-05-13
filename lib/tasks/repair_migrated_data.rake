namespace :repair_migrated_data do
  desc "Adds missing default locations"
  task add_missing_default_location_to_organisations: :environment do
    missing_default_locations = Organisation.all.select do |org|
      org.locations.empty?
    end

    missing_default_locations.each do |org|
      org.locations.create!
    end
  end

  desc "Confirms and creates passwords for users"
  task confirm_and_create_passwords_for_users: :environment do
    User.all.find_each do |user|
      random_password = Devise.friendly_token.first(16)
      user.update!(
        password: random_password,
        confirmed_at: user.created_at,
      )
    end
  end
end
