FactoryBot.define do
  factory :organisation do
    sequence :name, Organisation.fetch_organisations_from_register.cycle

    service_email { Faker::Internet.email }

    trait :with_locations do
      after :create do |org|
        org.locations << create_list(:location, 3)
      end
    end

    trait :with_location_and_ip do
      after :create do |org|
        org.locations << create(:location, :with_ip)
      end
    end
  end
end
