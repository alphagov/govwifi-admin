FactoryBot.define do
  factory :location do
    address { Faker::Address.street_address }
    postcode { Faker::Address.zip_code }

    trait :with_organisation do
      association :organisation
    end
  end
end
