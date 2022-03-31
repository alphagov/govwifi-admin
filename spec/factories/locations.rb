FactoryBot.define do
  factory :location do
    address { Faker::Address.street_address }
    postcode { Faker::Address.postcode }
    association :organisation

    trait :with_organisation do
      after(:create) do |location|
        create(:organisation, locations: [location])
        location.reload
      end
    end

    trait :with_ip do
      after(:create) do |location|
        create(:ip, location:)
        location.reload
      end
    end
  end
end
