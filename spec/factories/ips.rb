FactoryBot.define do
  factory :ip do
    address { '10.0.0.1' }

    trait :with_location_and_organisation do
      association :location, :with_organisation
    end
  end
end
