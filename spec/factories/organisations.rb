FactoryBot.define do
  factory :organisation do
    sequence :name do |n|
      "Gov Org #{n}"
    end

    service_email { Faker::Internet.email }

    trait :with_locations do
      after :create do |org|
        create_list(:location, 3, organisation: org)
        org.reload
      end
    end

    trait :with_location_and_ip do
      after :create do |org|
        create(:location, :with_ip, organisation: org)
        org.reload
      end
    end

    trait :with_cba_enabled do
      after :create do |org|
        org.enable_cba_feature!
        org.reload
      end
    end
  end
end
